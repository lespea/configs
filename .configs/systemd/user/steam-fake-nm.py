#!/usr/bin/python3
"""Minimal read-only fake NetworkManager for Steam.

Steam's login screen waits for libnm to report a connected device before
logging on; with systemd-networkd there is no NetworkManager, so it always
sits on "Waiting for network" until a 10s timeout
(https://github.com/ValveSoftware/steam-for-linux/issues/9966).

This claims org.freedesktop.NetworkManager on the system bus (needs
steam-fake-nm.conf installed in /etc/dbus-1/system.d/) and exposes a single
activated wired device describing the interface that holds the default route.
Every mutating call is rejected.
"""

import json
import os
import socket
import subprocess
import uuid

import dbus
import dbus.service
from dbus.mainloop.glib import DBusGMainLoop
from gi.repository import GLib

NM = "org.freedesktop.NetworkManager"
PROPS = "org.freedesktop.DBus.Properties"
OBJ_MGR = "org.freedesktop.DBus.ObjectManager"

ROOT = "/org/freedesktop/NetworkManager"
DEV = f"{ROOT}/Devices/1"
ACTIVE = f"{ROOT}/ActiveConnection/1"
IP4 = f"{ROOT}/IP4Config/1"
IP6 = f"{ROOT}/IP6Config/1"
SETTINGS = f"{ROOT}/Settings"
CONN = f"{SETTINGS}/1"
NO_PATH = dbus.ObjectPath("/")

NM_STATE_CONNECTED_GLOBAL = 70
NM_CONNECTIVITY_FULL = 4
NM_DEVICE_TYPE_ETHERNET = 1
NM_DEVICE_STATE_ACTIVATED = 100
NM_ACTIVE_CONNECTION_STATE_ACTIVATED = 2


def u(n):
    return dbus.UInt32(n)


def paths(*p):
    return dbus.Array([dbus.ObjectPath(x) for x in p], signature="o")


def strs(*s):
    return dbus.Array(s, signature="s")


def props(**kv):
    return dbus.Dictionary(kv, signature="sv")


def dict_list(items):
    return dbus.Array([props(**i) for i in items], signature="a{sv}")


def ip_json(*args):
    out = subprocess.run(
        ["ip", "-j", *args], capture_output=True, check=True, text=True
    ).stdout
    return json.loads(out or "[]")


def network_info():
    route4 = ip_json("-4", "route", "show", "default")[0]
    iface = route4["dev"]
    gw6 = next(
        (
            r.get("gateway", "")
            for r in ip_json("-6", "route", "show", "default")
            if r.get("dev") == iface
        ),
        "",
    )
    link = ip_json("addr", "show", "dev", iface)[0]

    def addrs(family):
        return [
            (a["local"], a["prefixlen"])
            for a in link.get("addr_info", [])
            if a["family"] == family and a.get("scope") == "global"
        ]

    dns4, dns6 = [], []
    try:
        with open("/run/systemd/resolve/resolv.conf") as f:
            for line in f:
                if line.startswith("nameserver"):
                    ns = line.split()[1]
                    (dns6 if ":" in ns else dns4).append(ns)
    except OSError:
        pass

    try:
        with open(f"/sys/class/net/{iface}/speed") as f:
            speed = max(int(f.read()), 0)
    except (OSError, ValueError):
        speed = 0

    return {
        "iface": iface,
        "mac": link.get("address", "").upper(),
        "mtu": link.get("mtu", 1500),
        "speed": speed,
        "gw4": route4.get("gateway", ""),
        "gw6": gw6,
        "addr4": addrs("inet"),
        "addr6": addrs("inet6"),
        "dns4": dns4,
        "dns6": dns6,
    }


def read_only(*_):
    raise dbus.exceptions.DBusException(
        "fake NetworkManager is read-only",
        name="org.freedesktop.DBus.Error.AccessDenied",
    )


class Obj(dbus.service.Object):
    """An exported object whose properties are a static {interface: {name: value}} map."""

    def __init__(self, bus, path, ifaces):
        super().__init__(bus, path)
        self.path = path
        self.ifaces = ifaces

    @dbus.service.method(PROPS, in_signature="ss", out_signature="v")
    def Get(self, iface, prop):
        try:
            return self.ifaces[iface][prop]
        except KeyError:
            raise dbus.exceptions.DBusException(
                f"No such property {iface}.{prop}",
                name="org.freedesktop.DBus.Error.UnknownProperty",
            ) from None

    @dbus.service.method(PROPS, in_signature="s", out_signature="a{sv}")
    def GetAll(self, iface):
        return self.ifaces.get(iface, props())

    @dbus.service.method(PROPS, in_signature="ssv")
    def Set(self, iface, prop, value):
        read_only()


class Manager(Obj):
    @dbus.service.method(NM, out_signature="ao")
    def GetDevices(self):
        return paths(DEV)

    @dbus.service.method(NM, out_signature="ao")
    def GetAllDevices(self):
        return paths(DEV)

    @dbus.service.method(NM, out_signature="u")
    def state(self):
        return u(NM_STATE_CONNECTED_GLOBAL)

    @dbus.service.method(NM, out_signature="u")
    def CheckConnectivity(self):
        return u(NM_CONNECTIVITY_FULL)

    @dbus.service.method(NM, out_signature="a{ss}")
    def GetPermissions(self):
        return dbus.Dictionary({}, signature="ss")

    @dbus.service.method(NM, in_signature="b")
    def Enable(self, enable):
        read_only()

    @dbus.service.method(NM, in_signature="ooo", out_signature="o")
    def ActivateConnection(self, conn, dev, specific):
        read_only()

    @dbus.service.method(NM, in_signature="a{sa{sv}}oo", out_signature="oo")
    def AddAndActivateConnection(self, conn, dev, specific):
        read_only()

    @dbus.service.method(NM, in_signature="o")
    def DeactivateConnection(self, active):
        read_only()


class Settings(Obj):
    @dbus.service.method(f"{NM}.Settings", out_signature="ao")
    def ListConnections(self):
        return paths(CONN)

    @dbus.service.method(f"{NM}.Settings", in_signature="s", out_signature="o")
    def GetConnectionByUuid(self, conn_uuid):
        if conn_uuid == self.conn_uuid:
            return dbus.ObjectPath(CONN)
        raise dbus.exceptions.DBusException(
            "No such connection", name=f"{NM}.Settings.InvalidConnection"
        )

    @dbus.service.method(f"{NM}.Settings", in_signature="a{sa{sv}}", out_signature="o")
    def AddConnection(self, conn):
        read_only()


class Connection(Obj):
    @dbus.service.method(f"{NM}.Settings.Connection", out_signature="a{sa{sv}}")
    def GetSettings(self):
        return self.settings

    @dbus.service.method(
        f"{NM}.Settings.Connection", in_signature="s", out_signature="a{sa{sv}}"
    )
    def GetSecrets(self, setting):
        return dbus.Dictionary({}, signature="sa{sv}")

    @dbus.service.method(f"{NM}.Settings.Connection", in_signature="a{sa{sv}}")
    def Update(self, conn):
        read_only()

    @dbus.service.method(f"{NM}.Settings.Connection")
    def Delete(self):
        read_only()


class ObjectManager(dbus.service.Object):
    def __init__(self, bus, objs):
        super().__init__(bus, "/org/freedesktop")
        self.objs = objs

    @dbus.service.method(OBJ_MGR, out_signature="a{oa{sa{sv}}}")
    def GetManagedObjects(self):
        return dbus.Dictionary(
            {
                dbus.ObjectPath(o.path): dbus.Dictionary(o.ifaces, signature="sa{sv}")
                for o in self.objs
            },
            signature="oa{sa{sv}}",
        )


def export(bus, net):
    iface = net["iface"]
    conn_uuid = str(uuid.uuid5(uuid.NAMESPACE_URL, f"steam-fake-nm:{iface}"))
    dns4_u32 = [u(int.from_bytes(socket.inet_aton(a), "little")) for a in net["dns4"]]

    manager = Manager(
        bus,
        ROOT,
        {
            NM: props(
                Devices=paths(DEV),
                AllDevices=paths(DEV),
                Checkpoints=paths(),
                NetworkingEnabled=True,
                WirelessEnabled=False,
                WirelessHardwareEnabled=False,
                WwanEnabled=False,
                WwanHardwareEnabled=False,
                WimaxEnabled=False,
                WimaxHardwareEnabled=False,
                RadioFlags=u(0),
                ActiveConnections=paths(ACTIVE),
                PrimaryConnection=dbus.ObjectPath(ACTIVE),
                PrimaryConnectionType="802-3-ethernet",
                Metered=u(4),  # NM_METERED_GUESS_NO
                ActivatingConnection=NO_PATH,
                Startup=False,
                Version="1.58.1",
                VersionInfo=dbus.Array([u(1 << 16 | 58 << 8 | 1)], signature="u"),
                Capabilities=dbus.Array([], signature="u"),
                State=u(NM_STATE_CONNECTED_GLOBAL),
                Connectivity=u(NM_CONNECTIVITY_FULL),
                ConnectivityCheckAvailable=False,
                ConnectivityCheckEnabled=False,
                ConnectivityCheckUri="",
                GlobalDnsConfiguration=props(),
            )
        },
    )

    device = Obj(
        bus,
        DEV,
        {
            f"{NM}.Device": props(
                Udi=f"/sys/class/net/{iface}",
                Path="",
                Interface=iface,
                IpInterface=iface,
                Driver="",
                DriverVersion="",
                FirmwareVersion="",
                Capabilities=u(0x3),  # NM_SUPPORTED | CARRIER_DETECT
                Ip4Address=u(0),
                State=u(NM_DEVICE_STATE_ACTIVATED),
                StateReason=dbus.Struct(
                    (u(NM_DEVICE_STATE_ACTIVATED), u(0)), signature="uu"
                ),
                ActiveConnection=dbus.ObjectPath(ACTIVE),
                Ip4Config=dbus.ObjectPath(IP4),
                Dhcp4Config=NO_PATH,
                Ip6Config=dbus.ObjectPath(IP6),
                Dhcp6Config=NO_PATH,
                Managed=True,
                Autoconnect=True,
                FirmwareMissing=False,
                NmPluginMissing=False,
                DeviceType=u(NM_DEVICE_TYPE_ETHERNET),
                AvailableConnections=paths(CONN),
                PhysicalPortId="",
                Mtu=u(net["mtu"]),
                Metered=u(4),
                LldpNeighbors=dbus.Array([], signature="a{sv}"),
                Real=True,
                Ip4Connectivity=u(NM_CONNECTIVITY_FULL),
                Ip6Connectivity=u(NM_CONNECTIVITY_FULL if net["gw6"] else 1),
                InterfaceFlags=u(0x10001),  # UP | CARRIER
                HwAddress=net["mac"],
                Ports=paths(),
            ),
            f"{NM}.Device.Wired": props(
                HwAddress=net["mac"],
                PermHwAddress=net["mac"],
                Speed=u(net["speed"]),
                S390Subchannels=strs(),
                Carrier=True,
            ),
        },
    )

    active = Obj(
        bus,
        ACTIVE,
        {
            f"{NM}.Connection.Active": props(
                Connection=dbus.ObjectPath(CONN),
                SpecificObject=NO_PATH,
                Id=iface,
                Uuid=conn_uuid,
                Type="802-3-ethernet",
                Devices=paths(DEV),
                State=u(NM_ACTIVE_CONNECTION_STATE_ACTIVATED),
                StateFlags=u(0),
                Default=True,
                Ip4Config=dbus.ObjectPath(IP4),
                Dhcp4Config=NO_PATH,
                Default6=bool(net["gw6"]),
                Ip6Config=dbus.ObjectPath(IP6),
                Dhcp6Config=NO_PATH,
                Vpn=False,
                Controller=NO_PATH,
                Master=NO_PATH,
            )
        },
    )

    ip4 = Obj(
        bus,
        IP4,
        {
            f"{NM}.IP4Config": props(
                Addresses=dbus.Array([], signature="au"),
                AddressData=dict_list(
                    {"address": a, "prefix": u(p)} for a, p in net["addr4"]
                ),
                Gateway=net["gw4"],
                Routes=dbus.Array([], signature="au"),
                RouteData=dbus.Array([], signature="a{sv}"),
                Nameservers=dbus.Array(dns4_u32, signature="u"),
                NameserverData=dict_list({"address": a} for a in net["dns4"]),
                Domains=strs(),
                Searches=strs(),
                DnsOptions=strs(),
                DnsPriority=dbus.Int32(0),
                WinsServers=dbus.Array([], signature="u"),
                WinsServerData=strs(),
            )
        },
    )

    ip6 = Obj(
        bus,
        IP6,
        {
            f"{NM}.IP6Config": props(
                Addresses=dbus.Array([], signature="(ayuay)"),
                AddressData=dict_list(
                    {"address": a, "prefix": u(p)} for a, p in net["addr6"]
                ),
                Gateway=net["gw6"],
                Routes=dbus.Array([], signature="(ayuayu)"),
                RouteData=dbus.Array([], signature="a{sv}"),
                Nameservers=dbus.Array(
                    [
                        dbus.ByteArray(socket.inet_pton(socket.AF_INET6, a))
                        for a in net["dns6"]
                    ],
                    signature="ay",
                ),
                Domains=strs(),
                Searches=strs(),
                DnsOptions=strs(),
                DnsPriority=dbus.Int32(0),
            )
        },
    )

    settings = Settings(
        bus,
        SETTINGS,
        {
            f"{NM}.Settings": props(
                Connections=paths(CONN),
                Hostname=socket.gethostname(),
                CanModify=False,
                VersionId=dbus.UInt64(1),
            )
        },
    )
    settings.conn_uuid = conn_uuid

    conn = Connection(
        bus,
        CONN,
        {
            f"{NM}.Settings.Connection": props(
                Unsaved=False,
                Flags=u(0),
                Filename="",
            )
        },
    )
    conn.settings = dbus.Dictionary(
        {
            "connection": props(
                id=iface,
                uuid=conn_uuid,
                type="802-3-ethernet",
                **{"interface-name": iface},
                autoconnect=True,
            ),
            "802-3-ethernet": props(),
            "ipv4": props(method="auto"),
            "ipv6": props(method="auto"),
        },
        signature="sa{sv}",
    )

    objs = [manager, device, active, ip4, ip6, settings, conn]
    return [ObjectManager(bus, objs), *objs]


def notify_ready():
    addr = os.environ.get("NOTIFY_SOCKET")
    if not addr:
        return
    if addr[0] == "@":
        addr = "\0" + addr[1:]
    with socket.socket(socket.AF_UNIX, socket.SOCK_DGRAM | socket.SOCK_CLOEXEC) as s:
        s.connect(addr)
        s.sendall(b"READY=1")


def main():
    DBusGMainLoop(set_as_default=True)
    bus = dbus.SystemBus()
    objs = export(bus, network_info())  # noqa: F841 - keep exported objects alive
    # Claim the name only after everything is exported so libnm never sees a partial tree.
    name = dbus.service.BusName(NM, bus, do_not_queue=True)  # noqa: F841
    notify_ready()
    GLib.MainLoop().run()


if __name__ == "__main__":
    main()
