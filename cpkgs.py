#!/usr/bin/env python3

import argparse
import io
import json
import math
import os
import platform
import re
import subprocess
import sys
import time
import typing
from typing import Optional

GROUP_NAME = "cargo_pkgs"

only_pkgs = {}


def validate_pueue(recheck: bool = False):
    out = subprocess.check_output(["pueue", "status", "-g", "default"])

    if b"running" not in out:
        if recheck:
            raise RuntimeError("Pueue status couldn't be determined?")
        else:
            subprocess.check_call(["pueued", "-d"])
            validate_pueue(True)


def get_run_info() -> typing.Tuple[os._Environ, bool]:
    env = os.environ

    nix = is_nix()
    mold = nix

    if nix or is_dar():
        if nix:
            cflags = [
                "-march=native",
                "-mtune=native",
                "-fstack-clash-protection",
                "-fcf-protection",
            ]
        else:
            cflags = []

        cflags = cflags + [
            # "-O2",
            "-pipe",
            "-fno-plt",
            "-fexceptions",
            "-Wp,-D_FORTIFY_SOURCE=2",
            "-Wformat",
            "-Werror=format-security",
        ]

        env["CFLAGS"] = " ".join(cflags)
        env["CXXFLAGS"] = " ".join(cflags + ["-Wp,-D_GLIBCXX_ASSERTIONS"])
        if nix:
            env["LDFLAGS"] = "-Wl,-O1,--sort-common,--as-needed,-z,relro,-z,now"
        else:
            env["LDFLAGS"] = "-pie"
        env["LTOFLAGS"] = "-flto=auto"
        env["MAKEFLAGS"] = "-j20"
        env["RUSTFLAGS"] = "-C link-args=-s -C target-cpu=native"

    return env, mold


def run_cmds(*cmds: list[str]):
    for cmd in cmds:
        subprocess.check_call(cmd)


def setup_groups():
    if GROUP_NAME.encode() in subprocess.check_output(["pueue", "group"]):
        run_cmds(
            ["pueue", "kill", "-g", GROUP_NAME],
            ["pueue", "clean", "-g", GROUP_NAME],
        )

        time.sleep(1)

        out = json.loads(
            subprocess.check_output(
                [
                    "pueue",
                    "status",
                    "-j",
                    "-g",
                    GROUP_NAME,
                ]
            )
        )["tasks"]

        for id, _ in out.items():
            subprocess.check_call(["pueue", "remove", id])

        time.sleep(0.5)

        run_cmds(
            ["pueue", "kill", "-g", GROUP_NAME],
            ["pueue", "clean", "-g", GROUP_NAME],
            ["pueue", "group", "remove", GROUP_NAME],
        )

    cores = math.ceil((os.cpu_count() or 8) / 4)

    run_cmds(
        ["pueue", "group", "add", GROUP_NAME],
        ["pueue", "parallel", "-g", GROUP_NAME, str(cores)],
    )


def wait_and_clean():
    run_cmds(
        ["pueue", "wait", "-g", GROUP_NAME],
        # ['pueue', 'clean', '-g', GROUP_NAME],
        # ['pueue', 'group', 'remove', GROUP_NAME],
    )


def install(args):
    limit = set()
    if args.missing:
        limit = find_installed(True)
        if len(limit) == 0:
            print("No outdated packages found")
            if args.packages is None:
                return
        else:
            print(f"Found {len(limit)} outdated packages: {', '.join(limit)}")

    if args.packages is not None:
        for pkgs in args.packages:
            for pkg in pkgs.split(","):
                limit.add(pkg.strip())

    pkgs = get_packages(limit)
    if len(pkgs) == 0:
        print("No packages to install")
        return

    (env, is_mold) = get_run_info()

    validate_pueue()
    setup_groups()
    for pkg in pkgs:
        if len(only_pkgs) == 0 or pkg.pkg in only_pkgs:
            runenv = env

            # Merge the envs if there are any
            if pkg.envs is not None:
                runenv = env.copy()
                for k, v in pkg.envs.items():
                    runenv[k] = v

            subprocess.check_call(pkg.args(is_mold, args.force), env=runenv)
    wait_and_clean()


def find_installed(only_outdated: bool) -> set[str]:
    pkg = re.compile(r"""(?i)^(\S+)\s+v.*(yes|no)$""")
    pkgs = set()

    out = subprocess.check_output(["cargo", "install-update", "-al"]).decode()
    for line in io.StringIO(out):
        m = pkg.match(line)
        if m is not None:
            if only_outdated and m.group(2).lower() == "no":
                continue
            pkgs.add(m.group(1))

    return pkgs


def find_missing(_):
    pkgs = find_installed(False)

    missing = set()
    for pInfo in get_packages(set()):
        name = pInfo.pkg
        if name not in pkgs:
            missing.add(name)

    if len(missing) > 0:
        print("Missing the follow packages: " + ", ".join(missing))
    else:
        print("No missing packages found!")


def list_all_pkgs(_):
    for pInfo in sort_packages(get_packages(set())):
        print(pInfo)


def main():
    # Setup
    parser = argparse.ArgumentParser(
        prog="Cargo Packages", description="Installs our wanted rust applications"
    )
    sub = parser.add_subparsers(required=True)

    # Install
    inst = sub.add_parser(
        "install", description="Installs our wanted rust applications"
    )

    inst.add_argument(
        "-f", "--force", action="store_true", help="force install via cargo"
    )

    inst.add_argument(
        "-p", "--packages", action="append", help="install a specific package"
    )

    inst.add_argument(
        "-m",
        "--missing",
        action="store_true",
        help="include all outdated packages as reported by install-update; merged with -p",
    )

    inst.set_defaults(func=install)

    # Missing
    missing = sub.add_parser(
        "missing", description="Finds any cargo packages not managed by this helper"
    )
    missing.set_defaults(func=find_missing)

    # List
    list_pkgs = sub.add_parser("list", description="List all the packages + args")
    list_pkgs.set_defaults(func=list_all_pkgs)

    # Parse and run
    args = parser.parse_args(["install"] if len(sys.argv) == 1 else None)

    args.func(args)


class PkgInfo:
    def __init__(
        self,
        pkg: str,
        use_defaults: bool = True,
        nightly: bool = False,
        locked: bool = False,
        high_priority: bool = False,
        disabled: bool = False,
        features: Optional[list[str]] = None,
        envs: Optional[dict[str, str]] = None,
        extras: Optional[list[str]] = None,
    ):
        self.pkg = pkg
        self.use_defaults = use_defaults
        self.high_priority = high_priority
        self.nightly = nightly
        self.locked = locked
        self.disabled = disabled

        self.envs = envs
        self.extras = extras

        if features is None:
            self.features = []
        else:
            self.features = sorted(features)

    def __repr__(self):
        features = ""
        if len(self.features) > 0:
            features = f"; ({', '.join(self.features)})"

        extra = []

        if not self.use_defaults:
            extra.append("no_defaults")

        if self.high_priority:
            extra.append("high_priority")
        if self.nightly:
            extra.append("nightly")
        if self.locked:
            extra.append("locked")

        if self.extras:
            extra.extend(self.extras)

        extra_str = ""
        if len(extra) > 0:
            extra_str = f"; [{', '.join(extra)}]"

        return f"PkgInfo({self.pkg}{features}{extra_str})"

    def args(self, mold: bool, force: bool) -> list[str]:
        a = [
            "pueue",
            "add",
            "--group",
            GROUP_NAME,
            "--label",
            self.pkg,
        ]

        if mold:
            a.extend(("mold", "--run"))

        a.append("cargo")
        if self.nightly:
            a.append("+nightly")
        a.extend(("install", self.pkg))

        if not self.use_defaults:
            a.append("--no-default-features")

        if len(self.features) > 0:
            a.append("--features")
            a.append(",".join(self.features))

        if self.locked:
            a.append("--locked")

        if force:
            a.append("--force")

        if self.extras:
            a.extend(self.extras)

        return a


def sort_packages(pkgs: list[PkgInfo]) -> list[PkgInfo]:
    return sorted(
        [p for p in pkgs if not p.disabled], key=lambda x: (not x.high_priority, x.pkg)
    )


def get_packages(limit: set[str]) -> list[PkgInfo]:
    want = [
        PkgInfo("b3sum"),
        PkgInfo("bacon"),
        PkgInfo("bat"),
        PkgInfo("bingrep"),
        PkgInfo("blake2_bin"),
        PkgInfo("broot"),
        PkgInfo("cargo-audit"),
        PkgInfo("cargo-cache"),
        PkgInfo("cargo-edit"),
        PkgInfo("cargo-geiger"),
        PkgInfo("cargo-generate"),
        PkgInfo("cargo-nextest"),
        PkgInfo("cargo-outdated"),
        PkgInfo("cargo-show-asm"),
        PkgInfo("cargo-update"),
        PkgInfo("csview"),
        PkgInfo("difftastic"),
        PkgInfo("dprint"),
        PkgInfo("du-dust"),
        PkgInfo("eza"),
        PkgInfo("fd-find"),
        PkgInfo("fse_dump"),
        PkgInfo("git-delta"),
        PkgInfo("gitoxide"),
        PkgInfo("gping"),
        PkgInfo("hexyl"),
        PkgInfo("ht"),
        PkgInfo("hyperfine"),
        PkgInfo("igrep"),
        PkgInfo("jsonxf"),
        PkgInfo("just"),
        PkgInfo("just-lsp"),
        PkgInfo("kondo"),
        PkgInfo("lscolors", features=["crossterm", "nu-ansi-term"]),
        PkgInfo("mdcat"),
        PkgInfo("miniserve"),
        PkgInfo("nickel-lang-cli", high_priority=True),
        PkgInfo("onefetch"),
        PkgInfo("ouch"),
        PkgInfo("procs"),
        PkgInfo("ptail"),
        PkgInfo("ripgrep", features=["pcre2"], extras=["--profile", "release-lto"]),
        PkgInfo("ripgrep_all"),
        PkgInfo("sd"),
        PkgInfo("simple-http-server"),
        PkgInfo("stylua"),
        PkgInfo("tokei", features=["all"]),
        PkgInfo("trippy"),
        PkgInfo("vivid"),
        PkgInfo("watchexec-cli"),
        PkgInfo("zoxide"),
    ]

    nix_pkgs = [
        PkgInfo("atuin", use_defaults=False, features=["client", "daemon"]),
        PkgInfo("bandwhich"),
        PkgInfo("bottom"),
        PkgInfo("gitui", locked=True),
        PkgInfo("jless"),
        PkgInfo(
            "mise",
            high_priority=True,
            locked=True,
            use_defaults=False,
            features=[
                "rustls-native-roots",
                "self_update",
                "vfox/vendored-lua",
            ],
            extras=["--profile", "serious"],
        ),
        PkgInfo("skim"),
        PkgInfo("systemd-lsp"),
        # PkgInfo("topgrade", high_priority=True),
        PkgInfo("usage-cli"),
        PkgInfo("wasm-pack"),
        PkgInfo("xcp"),
    ]

    win_pkgs = [
        PkgInfo("czkawka_cli", high_priority=True),
        PkgInfo("nu", locked=True),
        PkgInfo("pueue"),
        PkgInfo("starship", high_priority=True),
    ]

    gui_pkgs = [
        PkgInfo("czkawka_gui", high_priority=True),
    ]

    server_pkgs = [
        PkgInfo("czkawka_cli", high_priority=True),
    ]

    if is_nix():
        uutils_feat = "unix"
        want.extend(nix_pkgs)

        sess = os.getenv("XDG_SESSION_TYPE")
        if sess is None or sess != "wayland":
            want.extend(server_pkgs)
        else:
            want.extend(gui_pkgs)

    elif is_dar():
        uutils_feat = "macos"
        want.extend(nix_pkgs)
        want.extend(gui_pkgs)

    elif is_win():
        uutils_feat = "windows"
        want.extend(win_pkgs)

    else:
        raise RuntimeError("Weird platform? " + platform.system())

    want.append(
        PkgInfo(
            "coreutils",
            high_priority=True,
            features=[uutils_feat],
            envs={
                "PROJECT_NAME_FOR_VERSION_STRING": "coreurilts-local",
            },
        )
    )

    if len(limit) > 0:
        want = [x for x in want if x.pkg in limit]

    return sort_packages(want)


def is_win():
    return platform.system() == "Windows"


def is_dar():
    return platform.system() == "Darwin"


def is_nix():
    return platform.system() == "Linux"


if __name__ == "__main__":
    main()
