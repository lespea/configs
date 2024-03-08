#!/usr/bin/env python

import subprocess
import pathlib

from itertools import chain
from collections.abc import Iterable


# ╭──────────────────────────────────────────────────────────────────────────────╮
# │                                    Setup                                     │
# ╰──────────────────────────────────────────────────────────────────────────────╯

IS_DESK = True
SKIP_AUR = True
REALLY_RUN = False
PACSTRAP_BASE = None


def combine(*sets: Iterable[str]) -> set[str]:
    s = set()
    for st in sets:
        s.update(st)
    return s


def multi(
    any: Iterable[set[str]] = (),
    desk: Iterable[set[str]] = (),
    server: Iterable[set[str]] = (),
    none: Iterable[set[str]] = (),  # Included to supress warnings
) -> set[str]:
    # Ignore
    _ = none

    if IS_DESK:
        return combine(*chain(any, desk))
    else:
        return combine(*chain(any, server))


# ╭──────────────────────────────────────────────────────────────────────────────╮
# │                                     Base                                     │
# ╰──────────────────────────────────────────────────────────────────────────────╯


def base() -> set[str]:
    # Boot utils
    boots = {
        "memtest86+-efi",
    }

    # Compression
    compression = {
        "cabextract",
    }

    # Dbus + utils
    dbus = {
        "dbus-broker",
        "dbus-python",
        "ibus",
    }

    # Work with efi partitions/vars
    efi = {
        "dosfstools",
        "efibootmgr",
        "efitools",
        "efivar",
        "mtools",
        "syslinux",
        "systemd-boot-pacman-hook",
    }

    # Filesystems
    filesys = {
        "btrfs-progs",
        "exfatprogs",
        "f2fs-tools",
        "gpart",
        "gparted",
        "gptfdisk",
        "hdparm",
        "libnfs",
        "nfs-utils",
        "nfsidmap",
        "ntfs-3g",
        "nvme-cli",
        "open-iscsi",
        "zfs-dkms",
        "zfs-utils",
    }

    # Firmware for our hardware
    firmware = {
        "ccid",  # Usb drivers
        "linux-firmware",
        "linux-firmware-mellanox",
    }

    # Misc stuff
    utils = {
        "base",
        "busybox",
        "ddrescue",
        "dialog",
        "dmidecode",
        "etckeeper",
        "gksu",
        "htop",
        "i2c-tools",
        "iotop-c",
        "libblockdev-btrfs",
        "libblockdev-dm",
        "lm_sensors",
        "logrotate",
        "lrzsz",  # compression
        "lsof",
        "lzip",
        "lzop",
        "man-db",
        "man-pages",
        "memtester",
        "mkinitcpio-archiso",
        "mkinitcpio-systemd-tool",
        "mkinitcpio-utils",
        "overdue",
        "p7zip",
        "paccache-hook",
        "parallel",
        "picocom",
        "picom",
        "pigz",
        "polkit",
        "pv",
        "rebuild-detector",
        "reflector",
        "samba",
        "sbctl",
        "sbsigntools",
        "smartmontools",
        "snapper",
        "socat",
        "strace",
        "sudo",
        "testdisk",
        "time",
        "tinyxxd",
        "tmux",
        "unrar",
        "unzip",
        "which",
        "xz",
        "zellij",
        "zip",
        "zstd",
    }

    # The kernel to use
    kernel = {
        "linux-lts",
        "linux-lts-headers",
        "linux-zen",
        "linux-zen-headers",
    }

    # Networking tools
    networking = {
        "dnssec-tools",
        "ethtool",
        "inetutils",
        "ipcalc",
        "iptables-nft",
        "net-tools",
        "nss-mdns",
        "openssh",
        "openssl",
    }

    # Package management tools
    pacman = {
        "downgrade",
        "fakeroot",
        "pacman",
        "paru",
    }

    # Deal with power / scheduling
    power = {
        "cpupower",
    }

    # Shells we use
    shells = {
        "bash",
        "bash-completion",
        "fish",
        "fisher",
        "fzf",
        "powerline",
        "powerline-fonts",
        "zsh",
    }

    # CPU updates
    amd_ucode = {
        "amd-ucode",
    }

    intel_ucode = {
        "intel-ucode",
    }

    return multi(
        any=(
            boots,
            compression,
            dbus,
            efi,
            filesys,
            firmware,
            kernel,
            networking,
            pacman,
            power,
            shells,
            utils,
        ),
        desk=(amd_ucode,),
        server=(intel_ucode,),
    )


# ╭──────────────────────────────────────────────────────────────────────────────╮
# │ Containers                                                                   │
# ╰──────────────────────────────────────────────────────────────────────────────╯


def containers() -> set[str]:
    # Build tools
    build = {
        "docker-buildx",
        "docker-scan",
    }

    # Networking utils
    network = {
        "cni-plugins",  # networking
    }

    # Core podman
    podman = {
        "aardvark-dns",
        "fuse-overlayfs",
        "podman",
        "podman-compose",
        "podman-docker",
    }

    # Not a container but whatever
    qemu = {
        "qemu-emulators-full",
        "qemu-full",
        "qemu-tools",
        "spice-protocol",
        "spice-vdagent",
        "swtpm",
        "virt-install",
    }

    # Desktop utils
    qemu_desk = {
        "virt-manager",
    }

    return multi(
        any=(
            build,
            network,
            podman,
            qemu,
        ),
        desk=(qemu_desk,),
    )


# ╭──────────────────────────────────────────────────────────────────────────────╮
# │                                     Dev                                      │
# ╰──────────────────────────────────────────────────────────────────────────────╯


def dev() -> set[str]:
    c = {
        "autoconf",
        "automake",
        "base-devel",
        "bison",
        "boost",
        "ccache",
        "clang",
        "cmake",
        "cppcheck",
        "debugedit",
        "devtools",
        "gcc",
        "gcc-fortran",
        "gcc-libs",
        "gdb",
        "lcov",
        "lib32-gcc-libs",
        "libc++",
        "libc++abi",
        "libgccjit",
        "lld",
        "lldb",
        "llvm",
        "m4",
        "make",
        "meson",
        "mold",
        "mpdecimal",
        "musl",
        "ninja",
        "openmp",
        "openmpi",
        "patch",
        "pkgconf",
        "pkgfile",
        "sccache",
        "zig",
    }

    diff = {
        "diffutils",
        "git-delta",
        "kdiff3",
        "lazygit",
        "meld",
        "pacdiffviewer",
        "wdiff",
    }

    java = {
        "coursier",
        "gradle",
        "gradle-doc",
        "gradle-src",
        "java-runtime",
        "jdk-openjdk",
        "jetbrains-toolbox",
        "kotlin",
        "maven",
        "sbt",
        "scala",
        "visualvm",
    }

    jscript = {
        "node",
        "node-gyp",
        "nodejs",
        "nodejs-nopt",
        "npm",
        "pnpm",
        "semver",
        "svelte-language-server",
        "ts-node",
        "typescript",
        "typescript-language-server",
        "typescript-svelte-plugin",
        "yarn",
    }

    go = {
        "go",
        "gofumpt",
        "gojq",
        "gopls",
        "staticcheck",
    }

    misc = {
        "gcc-fortran",
        "ghc",
        "ghc-libs",
        "ghc-static",
        "git-cola",
        "jq",
        "julia",
        "ocaml",
        "r",
        "veoy-bin",
    }

    misc_all = {
        "chmlib",  # Microsoft itss/chm files
        "git",
        "hadolint-bin",
        "hexdump",
        "hexedit",
        "lazygit",
        "prettier",
        "tidy",
        "tig",
        "valgrind",
        "vc-intrinsics",
        "wimlib",
    }

    mono = {
        "mono",
        "mono-addins",
        "mono-msbuild",
        "mono-msbuild-sdkresolver",
        "mono-tools",
    }

    lua = {
        "libluv",
        "lua",
        "lua-argparse",
        "lua-filesystem",
        "lua-lanes",
        "lua-lpeg",
        "lua-sec",
        "lua-socket",
        "luacheck",
        "luajit",
        "luarocks",
        "stylua",
    }

    nvim = {
        "ctags",
        "neovide",
        "neovim",
        "python-pynvim",
        "tree-sitter-cli",
        "yaml-language-server",
    }

    ocaml = {
        "ocaml",
        "ocaml-bigarray-compat",
        "ocaml-compiler-libs",
        "ocaml-ctypes",
        "ocaml-integers",
        "ocaml-result",
        "ocaml-topkg",
    }

    #  Probably overkill but /shrug
    perl = {
        "perl",
        "perl-alien-build",
        "perl-alien-libxml2",
        "perl-anyevent",
        "perl-anyevent-i3",
        "perl-async-interrupt",
        "perl-autovivification",
        "perl-b-hooks-endofscope",
        "perl-business-isbn",
        "perl-business-isbn-data",
        "perl-business-ismn",
        "perl-business-issn",
        "perl-bytes-random-secure",
        "perl-canary-stability",
        "perl-capture-tiny",
        "perl-cgi",
        "perl-class-accessor",
        "perl-class-data-inheritable",
        "perl-class-inspector",
        "perl-class-load",
        "perl-class-singleton",
        "perl-clone",
        "perl-common-sense",
        "perl-crypt-openssl-bignum",
        "perl-crypt-openssl-dsa",
        "perl-crypt-openssl-random",
        "perl-crypt-openssl-rsa",
        "perl-crypt-passwdmd5",
        "perl-crypt-random-seed",
        "perl-crypt-random-tesha2",
        "perl-crypt-ssleay",
        "perl-data-compare",
        "perl-data-dump",
        "perl-data-optlist",
        "perl-data-uniqid",
        "perl-datetime",
        "perl-datetime-calendar-julian",
        "perl-datetime-format-builder",
        "perl-datetime-format-strptime",
        "perl-datetime-locale",
        "perl-datetime-timezone",
        "perl-dbi",
        "perl-devel-cover",
        "perl-devel-stacktrace",
        "perl-digest-bubblebabble",
        "perl-digest-hmac",
        "perl-digest-sha1",
        "perl-dist-checkconflicts",
        "perl-encode-locale",
        "perl-error",
        "perl-ev",
        "perl-eval-closure",
        "perl-exception-class",
        "perl-exporter-tiny",
        "perl-ffi-checklib",
        "perl-file-basedir",
        "perl-file-chdir",
        "perl-file-desktopentry",
        "perl-file-find-rule",
        "perl-file-listing",
        "perl-file-mimeinfo",
        "perl-file-sharedir",
        "perl-file-sharedir-install",
        "perl-file-slurp-tiny",
        "perl-file-slurper",
        "perl-file-which",
        "perl-guard",
        "perl-html-parser",
        "perl-html-tagset",
        "perl-http-cookiejar",
        "perl-http-cookies",
        "perl-http-daemon",
        "perl-http-date",
        "perl-http-message",
        "perl-http-negotiate",
        "perl-io-html",
        "perl-io-socket-inet6",
        "perl-io-socket-ssl",
        "perl-io-string",
        "perl-ipc-run3",
        "perl-ipc-system-simple",
        "perl-json",
        "perl-json-xs",
        "perl-libwww",
        "perl-lingua-translit",
        "perl-list-allutils",
        "perl-list-moreutils",
        "perl-list-moreutils-xs",
        "perl-list-someutils",
        "perl-list-utilsby",
        "perl-locale-gettext",
        "perl-log-log4perl",
        "perl-lwp-mediatypes",
        "perl-lwp-protocol-https",
        "perl-mailtools",
        "perl-math-random-isaac",
        "perl-math-round",
        "perl-memory-process",
        "perl-memory-usage",
        "perl-mime-base32",
        "perl-mime-charset",
        "perl-module-implementation",
        "perl-module-runtime",
        "perl-mozilla-ca",
        "perl-mro-compat",
        "perl-namespace-autoclean",
        "perl-namespace-clean",
        "perl-net-dbus",
        "perl-net-dns",
        "perl-net-dns-sec",
        "perl-net-http",
        "perl-net-ip",
        "perl-net-ssleay",
        "perl-number-compare",
        "perl-package-deprecationmanager",
        "perl-package-stash",
        "perl-package-stash-xs",
        "perl-params-util",
        "perl-params-validate",
        "perl-params-validationcompiler",
        "perl-parse-recdescent",
        "perl-path-class",
        "perl-path-tiny",
        "perl-perlio-utf8-strict",
        "perl-readonly",
        "perl-regexp-common",
        "perl-role-tiny",
        "perl-socket6",
        "perl-sort-key",
        "perl-specio",
        "perl-sub-exporter",
        "perl-sub-exporter-progressive",
        "perl-sub-identify",
        "perl-sub-install",
        "perl-term-readkey",
        "perl-test-fatal",
        "perl-text-bibtex",
        "perl-text-csv",
        "perl-text-glob",
        "perl-text-iconv",
        "perl-text-roman",
        "perl-tie-cycle",
        "perl-timedate",
        "perl-tk",
        "perl-try-tiny",
        "perl-types-serialiser",
        "perl-unicode-linebreak",
        "perl-uri",
        "perl-variable-magic",
        "perl-www-robotrules",
        "perl-x11-protocol",
        "perl-xml-libxml",
        "perl-xml-libxml-simple",
        "perl-xml-libxslt",
        "perl-xml-namespacesupport",
        "perl-xml-parser",
        "perl-xml-sax",
        "perl-xml-sax-base",
        "perl-xml-twig",
        "perl-xml-writer",
    }

    # Probably overkill but /shrug
    python = {
        "flake8",
        "ipython",
        "mypy",
        "python",
        "python-bcrypt",
        "python-beautifulsoup4",
        "python-bottleneck",
        "python-brotli",
        "python-build",
        "python-cairo",
        "python-cssselect",
        "python-curio",
        "python-dnspython",
        "python-fastimport",
        "python-flake8-black",
        "python-flake8-docstrings",
        "python-flake8-isort",
        "python-fqdn",
        "python-fs",
        "python-gobject",
        "python-gpgme",
        "python-graphviz",
        "python-h2",
        "python-html5lib",
        "python-installer",
        "python-isoduration",
        "python-jinja",
        "python-jsonpointer",
        "python-keyring",
        "python-keyrings-alt",
        "python-kivy",
        "python-lsp-black",
        "python-lxml",
        "python-lz4",
        "python-markdown",
        "python-matplotlib",
        "python-mutagen",
        "python-mysqlclient",
        "python-numba",
        "python-numexpr",
        "python-objgraph",
        "python-opengl",
        "python-openpyxl",
        "python-pandas",
        "python-pandas-datareader",
        "python-path",
        "python-pip",
        "python-pipx",
        "python-priority",
        "python-psutil",
        "python-pyasn1",
        "python-pycryptodome",
        "python-pycryptodomex",
        "python-pycurl",
        "python-pygit2",
        "python-pyinotify",
        "python-pylint",
        "python-pynvim",
        "python-pypcode",
        "python-pyqt5",
        "python-pyqt6",
        "python-pyserial",
        "python-pytest-flake8",
        "python-pyxdg",
        "python-rfc3339-validator",
        "python-rfc3987",
        "python-rope",
        "python-scipy",
        "python-service-identity",
        "python-setuptools",
        "python-snappy",
        "python-sniffio",
        "python-sympy",
        "python-tornado",
        "python-trio",
        "python-twisted",
        "python-uri-template",
        "python-webcolors",
        "python-whatthepatch",
        "python-wheel",
        "python-xarray",
        "python-xattr",
        "python-xlrd",
        "python-xlsxwriter",
        "python-xlwt",
        "python-yaml",
        "python-zstandard",
        "yapf",
    }

    rust = {
        "rust-musl",
        "rustup",
    }

    webassembly = {
        "binaryen",
        "wasi-compiler-rt",
        "wasi-libc++",
        "wasi-libc++abi",
    }

    wine = {
        "lib32-pcsclite",
        "wine",
        "wine-gecko",
        "wine-mono",
        "winetricks",
    }

    return multi(
        any=(
            c,
            diff,
            go,
            jscript,
            lua,
            misc_all,
            mono,
            nvim,
            perl,
            python,
            rust,
        ),
        desk=(
            java,
            misc,
            ocaml,
            webassembly,
            wine,
        ),
    )


# ╭──────────────────────────────────────────────────────────────────────────────╮
# │ Games                                                                        │
# ╰──────────────────────────────────────────────────────────────────────────────╯


def games() -> set[str]:
    steam = {
        "lib32-fluidsynth",
        "lib32-librsvg",
        "lib32-libxslt",
        "lib32-ocl-icd",
        "lib32-vkd3d",
        "proton-ge-custom-bin",
        "sdl12-compat",
        "sdl_image",
        "steam-native-runtime",
        "vkd3d",
    }

    return multi(desk=(steam,))


# ╭──────────────────────────────────────────────────────────────────────────────╮
# │                                  Misc tools                                  │
# ╰──────────────────────────────────────────────────────────────────────────────╯


def misc() -> set[str]:
    # Phone tools
    android = {
        "android-tools",
        "android-udev",
    }

    # Build our own arch things
    arch_tools = {
        "archiso",
    }

    # latex tooling
    latex = {
        "biber",
        "pandoc-cli",
        "pandoc-crossref",
        "tectonic",
        "texinfo",
        "texlive-basic",
        "texlive-bibtexextra",
        "texlive-bin",
        "texlive-binextra",
        "texlive-fontsextra",
        "texlive-fontutils",
        "texlive-formatsextra",
        "texlive-games",
        "texlive-humanities",
        "texlive-langenglish",
        "texlive-latexextra",
        "texlive-mathscience",
        "texlive-music",
        "texlive-pictures",
        "texlive-pstricks",
        "texlive-publishers",
        "texlive-xetex",
    }

    libs = {
        "libwmf",
        "libzip",
        "openjpeg2",
    }

    # Global media
    media_all = {
        "ffmpeg",
        "ffmpegthumbnailer",
        "libmediainfo",
        "mediainfo",
        "mkvtoolnix-cli",
    }

    # Media players/codecs/etc
    media = {
        "calf",
        "calligra",
        "chmlib",
        "ebook-tools",
        "gst-libav",
        "gst-plugin-pipewire",
        "gst-plugins-bad",
        "gst-plugins-base-libs",
        "gst-plugins-good",
        "gst-plugins-ugly",
        "lib32-gst-plugins-base",
        "lib32-gst-plugins-base-libs",
        "lib32-gst-plugins-good",
        "lib32-v4l-utils",
        "libshout",
        "live-media",
        "lsp-plugins-lv2",
        "mda.lv2",
        "mediainfo-gui",
        "mkvtoolnix-gui",
        "mpv",
        "mpv-mpris",
        "mpvqt",
        "obs-studio",
        "okular",
        "qmmp",
        "v4l-utils",
        "verapdf",
        "vlc",
        "zathura",
        "zathura-cb",
        "zathura-djvu",
        "zathura-pdf-mupdf",
        "zathura-ps",
    }

    # Misc things
    misc = {
        "atomicparsley",
        "catimg",
        "direnv",
        "dos2unix",
        "duf",
        "gnuplot",
        "graphviz",
        "icoutils",
        "imagemagick",
        "kwayland-integration",
        "kwayland5",
        "lcov",
        "libopenraw",
        "libraw",
        "mprime",
        "neofetch",
        "python-mutagen",
        "python-websockets",
        "python-xattr",
        "rclone",
        "yt-dlp",
        # "keychain", # stick with gpg-agent for now
    }

    # Misc things
    misc_desk = {
        "cheese",  # Webcam util
        "filelight",
        "gimp",
        "gimp-help-en",
        "gimp-nufraw",
        "gimp-plugin-gmic",
        "inkscape",
        "keepassxc",
        "signal-desktop",
        "slack-electron",
        "spotify",
        "tidal-hifi-bin",
        "vesktop-bin",
        "y-cruncher",
        "zoom",
    }

    # Libre office
    office = {
        "libreoffice-fresh",
    }

    # Printer stuff
    print = {
        "brother-mfc-l2710dw",
        "cups",
        "foomatic-db",
        "foomatic-db-engine",
        "foomatic-db-nonfree",
        "foomatic-db-nonfree-ppds",
        "foomatic-db-ppds",
        "ghostscript",
        "gv",
        "pstoedit",
        "psutils",
        "sane",
        "xsane-gimp",
    }

    # Remote support tools
    remote = {
        "anydesk-bin",
    }

    # Rust tools we use
    rust = {
        "bat",
        "dust",
        "eza",
        "fd",
        "hexyl",
        "lsd",
        "pueue",
        "ripgrep",
    }

    # Security tools we use
    sec_tools = {
        "cracklib",
        "fq",  # Binary inspector
        "gnu-netcat",
        "imhex",
        "john",
        "nmap",
        "tcpdump",
        "termshark",
        "wireshark-cli",
        "wireshark-qt",
    }

    # Spell checking tools
    spell = {
        "aiksaurus",
        "aspell",
        "aspell-en",
        "hspell",
        "hunspell-en_us",
        "hyphen-en",
        "libmythes",
        "mythes-en",
        "nuspell",
        "words",
    }

    virt = {
        "libvirt",
        "libvirt-dbus",
        "libvirt-storage-iscsi-direct",
    }

    return multi(
        any=(
            libs,
            media_all,
            misc,
            rust,
            spell,
            virt,
        ),
        desk=(
            android,
            arch_tools,
            media,
            misc_desk,
            office,
            print,
            remote,
            sec_tools,
        ),
        none=(latex,),
    )


# ╭──────────────────────────────────────────────────────────────────────────────╮
# │                                    Sound                                     │
# ╰──────────────────────────────────────────────────────────────────────────────╯


def sound() -> set[str]:
    # Legacy sound
    alsa = {
        "alsa-utils",
    }

    pipewire = {
        "pipewire",
        "pipewire-alsa",
        "pipewire-pulse",
        "pulseaudio-qt",
    }

    misc = {
        "easyeffects",
        "ladspa",
        "lib32-libcanberra",
        "libcanberra",
        "paprefs",
        "pavucontrol",
        "zam-plugins",
    }

    return multi(
        desk=(
            alsa,
            misc,
            pipewire,
        )
    )


# ╭──────────────────────────────────────────────────────────────────────────────╮
# │                                      UI                                      │
# ╰──────────────────────────────────────────────────────────────────────────────╯


def ui() -> set[str]:
    # Color correction
    cc = {
        "argyllcms",
        "displaycal",
    }

    cl = {
        "clinfo",
        "comgr",
        "extra/rocm-opencl-runtime",
        "hip-runtime-amd",
        "hipblas",
        "hsa-rocr",
        "lib32-opencl-clover-mesa",
        "lib32-opencl-rusticl-mesa",
        "miopen-hip",
        "ocl-icd",
        "opencl-clhpp",
        "opencl-clover-mesa",
        "opencl-headers",
        "opencl-rusticl-mesa",
        "opencv",
        "python-pytorch-rocm",
        "rccl",
        "rocalution",
        "rocblas",
        "rocfft",
        "rocm-clang-ocl",
        "rocm-core",
        "rocm-device-libs",
        "rocm-hip-libraries",
        "rocm-hip-runtime",
        "rocm-hip-sdk",
        "rocm-language-runtime",
        "rocm-llvm",
        "rocm-ml-libraries",
        "rocm-ml-sdk",
        "rocm-opencl-runtime",
        "rocm-opencl-sdk",
        # "tensorflow-cuda",
    }

    clipboard = {
        "clipman",
        "copyq",
        "flameshot",
        "grim",
        "slurp",
        "wl-clipboard",
        "xclip",
        "xsel",
    }

    # UI Engiens
    frameworks = {
        "gtk-engines",
        "gtk3",
        "gtk4",
        "wxwidgets-gtk3",
    }

    # Useful fonts
    fonts = {
        "adobe-source-code-pro-fonts",
        "awesome-terminal-fonts",
        "font-manager",
        "fontforge",
        "gnu-free-fonts",
        "nerd-fonts",
        "noto-fonts",
        "noto-fonts-cjk",
        "noto-fonts-emoji",
        "noto-fonts-extra",
        "otf-cascadia-code",
        "otf-crimson",
        "otf-crimson-pro",
        "otf-droid-nerd",
        "otf-eb-garamond",
        "otf-font-awesome",
        "otf-gandhifamily",
        "otf-intel-one-mono",
        "otf-vollkorn",
        "ttf-anonymouspro-nerd",
        "ttf-bitstream-vera",
        "ttf-bitstream-vera-mono-nerd",
        "ttf-cascadia-code",
        "ttf-cascadia-code-nerd",
        "ttf-croscore",
        "ttf-dejavu",
        "ttf-droid",
        "ttf-fira-mono",
        "ttf-firacode-nerd",
        "ttf-font-awesome",
        "ttf-go-nerd",
        "ttf-hack",
        "ttf-hack-nerd",
        "ttf-inconsolata-go-nerd",
        "ttf-inconsolata-lgc-nerd",
        "ttf-inconsolata-nerd",
        "ttf-intel-one-mono",
        "ttf-iosevka-nerd",
        "ttf-jetbrains-mono",
        "ttf-jetbrains-mono-nerd",
        "ttf-liberation",
        "ttf-liberation-mono-nerd",
        "ttf-mac-fonts",
        "ttf-merriweather",
        "ttf-merriweather-sans",
        "ttf-ms-win11-auto",
        "ttf-nerd-fonts-symbols-common",
        "ttf-nerd-fonts-symbols-mono",
        "ttf-noto-nerd",
        "ttf-roboto-mono-nerd",
        "ttf-ubuntu-font-family",
        "ttf-ubuntu-mono-nerd",
        "ttf-ubuntu-nerd",
        "unicode-emoji",
        "woff2-cascadia-code",
        "xorg-fonts-misc",
    }

    libs = {
        "libjxl",
        "libwebp",
        "twolame",
    }

    mesa = {
        "libspectre",
        "libva-mesa-driver",
        "libva-utils",
        "mesa",
        "mesa-utils",
    }

    mesa_vdpau = {
        "libva-vdpau-driver",
        "libvdpau-va-gl",
        "mesa-vdpau",
    }

    # Misc
    misc = {
        "electron",
        "geoip2-database",
        "kdialog",
        "lib32-libid3tag",
        "libid3tag",
        "nvtop",
        "polkit-kde-agent",
        "projectm-presets-cream-of-the-crop",
        "projectm-pulseaudio",
        "projectm-sdl",
        "radeontool",
        "radeontop",
        "tcl",
        "tk",
        "wofi",
        "wpaperd",
    }

    # QT libs
    qt = {
        "iio-sensor-proxy",
        "kimageformats5",
        "qt5",
        "qt5-3d",
        "qt5-charts",
        "qt5-connectivity",
        "qt5-datavis3d",
        "qt5-declarative",
        "qt5-doc",
        "qt5-examples",
        "qt5-gamepad",
        "qt5-graphicaleffects",
        "qt5-imageformats",
        "qt5-location",
        "qt5-lottie",
        "qt5-multimedia",
        "qt5-networkauth",
        "qt5-purchasing",
        "qt5-quick3d",
        "qt5-quickcontrols",
        "qt5-quickcontrols2",
        "qt5-quicktimeline",
        "qt5-remoteobjects",
        "qt5-script",
        "qt5-scxml",
        "qt5-sensors",
        "qt5-serialbus",
        "qt5-serialport",
        "qt5-speech",
        "qt5-tools",
        "qt5-virtualkeyboard",
        "qt5-wayland",
        "qt5-webchannel",
        "qt5-webengine",
        "qt5-webglplugin",
        "qt5-websockets",
        "qt5-webview",
        "qt5-xmlpatterns",
        "qt6",
        "qt6-3d",
        "qt6-5compat",
        "qt6-base",
        "qt6-charts",
        "qt6-connectivity",
        "qt6-datavis3d",
        "qt6-declarative",
        "qt6-doc",
        "qt6-examples",
        "qt6-imageformats",
        "qt6-languageserver",
        "qt6-lottie",
        "qt6-multimedia",
        "qt6-networkauth",
        "qt6-positioning",
        "qt6-quick3d",
        "qt6-quicktimeline",
        "qt6-remoteobjects",
        "qt6-scxml",
        "qt6-sensors",
        "qt6-serialbus",
        "qt6-serialport",
        "qt6-shadertools",
        "qt6-svg",
        "qt6-tools",
        "qt6-translations",
        "qt6-virtualkeyboard",
        "qt6-wayland",
        "qt6-webchannel",
        "qt6-webengine",
        "qt6-websockets",
        "qt6-webview",
    }

    # Our terminals we might use
    terminals = {
        "alacritty",
        "kitty",
    }

    terminfo = {
        "kitty-terminfo",
    }

    # Misc themese for GTK/QT
    themes = {
        "arc-gtk-theme",
        "arc-icon-theme",
        "breeze-gtk",
        "breeze-icons",
        "capitaine-cursors",
        "elementary-icon-theme",
        "gnome-themes-extra",
        "gtk-engine-murrine",
        "materia-gtk-theme",
    }

    # Make vulkan work
    vulkan = {
        "lib32-vulkan-icd-loader",
        "lib32-vulkan-radeon",
        "lib32-vulkan-virtio",
        "vulkan-extra-tools",
        "vulkan-html-docs",
        "vulkan-icd-loader",
        "vulkan-radeon",
        "vulkan-tools",
        "vulkan-virtio",
    }

    # Alt impl that we probably shouldn't use
    vulkan_dont_use = {
        "amdvlk",
    }

    # layers for multi gpu -- don't install for now
    vulkan_layers = {
        "lib32-vulkan-mesa-layers",
        "vulkan-extra-layers",
        "vulkan-mesa-layers",
        "vulkan-validation-layers",
    }

    wayland = {
        "hyprland",
        "lib32-libdecor",
        "libdecor",
        "mako",
        "waybar",
        "wayland-utils",
        "waylock",
        "wlroots",
        "wtype",
        "xdg-desktop-portal-hyprland",
    }

    xdg = {
        "xdg-desktop-portal",
        "xdg-desktop-portal-gtk",
        "xdg-desktop-portal-wlr",
    }

    xdg_base = {
        "xdg-dbus-proxy",
        "xdg-user-dirs",
        "xdg-utils",
    }

    xorg = {
        "wxsqlite3",
        "wxwidgets-common",
        "wxwidgets-qt5",
        "x11-ssh-askpass",
        "xboxdrv",
        "xclip",
        "xcompmgr",
        "xcursor-themes",
        "xf86-input-evdev",
        "xf86-input-libinput",
        "xf86-video-amdgpu",
        "xf86-video-vesa",
        "xfce4-clipman-plugin",
        "xfsdump",
        "xorg-bdftopcf",
        "xorg-docs",
        "xorg-font-util",
        "xorg-fonts-100dpi",
        "xorg-fonts-75dpi",
        "xorg-iceauth",
        "xorg-mkfontscale",
        "xorg-server",
        "xorg-server-devel",
        "xorg-server-xephyr",
        "xorg-server-xnest",
        "xorg-server-xvfb",
        "xorg-sessreg",
        "xorg-smproxy",
        "xorg-twm",
        "xorg-x11perf",
        "xorg-xauth",
        "xorg-xbacklight",
        "xorg-xclipboard",
        "xorg-xcmsdb",
        "xorg-xcursorgen",
        "xorg-xdpyinfo",
        "xorg-xdriinfo",
        "xorg-xev",
        "xorg-xgamma",
        "xorg-xhost",
        "xorg-xinit",
        "xorg-xinput",
        "xorg-xkbevd",
        "xorg-xkbutils",
        "xorg-xkill",
        "xorg-xlsatoms",
        "xorg-xlsclients",
        "xorg-xmodmap",
        "xorg-xpr",
        "xorg-xrdb",
        "xorg-xrefresh",
        "xorg-xsetroot",
        "xorg-xvinfo",
        "xorg-xwayland",
        "xorg-xwd",
        "xorg-xwininfo",
        "xorg-xwud",
        "xsel",
        "xss-lock",
        "xterm",
    }

    return multi(
        any=(
            libs,
            terminfo,
            xdg_base,
        ),
        desk=(
            cc,
            cl,
            clipboard,
            fonts,
            frameworks,
            mesa,
            mesa_vdpau,
            misc,
            qt,
            terminals,
            themes,
            vulkan,
            wayland,
            xdg,
            xorg,
        ),
        none=(vulkan_dont_use, vulkan_layers),
    )


# ╭──────────────────────────────────────────────────────────────────────────────╮
# │ Web                                                                          │
# ╰──────────────────────────────────────────────────────────────────────────────╯


def web():
    browsers = {
        "chromium",
        "firefox-developer-edition",
        "firefox-developer-edition-i18n-en-us",
        "webkit2gtk",
    }

    utils = {
        "curl",
        "httpie",
        "wget",
    }

    return multi(any=(utils,), desk=(browsers,))


# ╭──────────────────────────────────────────────────────────────────────────────╮
# │                                     Gen                                      │
# ╰──────────────────────────────────────────────────────────────────────────────╯


def run():
    pkgs = sorted(
        combine(
            base(),
            containers(),
            games(),
            misc(),
            sound(),
            ui(),
            web(),
        )
    )

    if SKIP_AUR:
        pkgs = sorted(set(pkgs) - aur())

    num_pkgs = len(pkgs)

    if PACSTRAP_BASE is not None and PACSTRAP_BASE != "":
        args = ["pacstrap", PACSTRAP_BASE]
    else:
        args = ["paru", "-S", "--needed"]

    args.extend(pkgs)
    cmd_str = " ".join(args)

    if REALLY_RUN:
        print(f"Installing {num_pkgs}: `{cmd_str}`")
        subprocess.check_call(args=args)
    else:
        print(f"Would have installed {num_pkgs} pkgs: `{cmd_str}`")


def paru():
    home = pathlib.Path.home()
    paru = home / "paru"

    cmds = [
        ("sudo pacman -S --needed base-devel git".split(" "), None),
        ("git clone https://aur.archlinux.org/paru.git".split(" "), home),
        ("makepkg -si".split(" "), paru),
    ]

    for cmd, dir in cmds:
        subprocess.check_call(args=cmd, cwd=dir)

    paru.unlink(missing_ok=True)


def want_paru() -> bool:
    try:
        subprocess.check_call(args=["paru", "--version"])
    except Exception:
        return True
    return False


def aur() -> set[str]:
    return {
        "anydesk-bin",
        "brother-mfc-l2710dw",
        "clipman",
        "downgrade",
        "gconf",
        "gksu",
        "httpdirfs",
        "icu56",
        "imhex",
        "libgksu",
        "mprime",
        "otf-eb-garamond",
        "otf-gandhifamily",
        "otf-intel-one-mono",
        "otf-vollkorn",
        "overdue",
        "paccache-hook",
        "projectm-git",
        "projectm-presets-cream-of-the-crop",
        "proton-ge-custom-bin",
        "slack-electron",
        "spotify",
        "systemd-boot-pacman-hook",
        "tidal-hifi-bin",
        "ttf-google-fonts-typewolf",
        "ttf-intel-one-mono",
        "ttf-mac-fonts",
        "ttf-merriweather-sans",
        "ttf-ms-win11-auto",
        "verapdf",
        "vesktop-bin",
        "wpaperd",
        "xboxdrv",
        "y-cruncher",
        "zfs-dkms",
        "zfs-utils",
        "zoom-system-qt",
    }


if __name__ == "__main__":
    if want_paru():
        paru()
    else:
        run()
