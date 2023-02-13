#!/usr/bin/env python3

from typing import Optional

import platform
import os
import subprocess


GROUP_NAME = 'cargo_pkgs'


def validate_pueue(recheck: bool = False):
    out = subprocess.check_output(
        ['pueue', 'status', '-g', 'default']
    )

    if b'running' not in out:
        if recheck:
            raise RuntimeError("Pueue status couldn't be determined?")
        else:
            subprocess.check_call(['pueued', '-d'])
            validate_pueue(True)


def get_run_info() -> (dict[str, str], bool):
    env = os.environ
    mold = False

    nix = is_nix()
    if nix or is_dar():
        mold = nix
        env['CFLAGS'] = ' '.join((
            '-march=native', '-mtune=native',
            '-O2', '-pipe',
            '-fno-plt', '-fexceptions',
            '-Wp,-D_FORTIFY_SOURCE=2', '-Wformat', '-Werror=format-security',
            '-fstack-clash-protection', '-fcf-protection',
        ))
        env['CXXFLAGS'] = env['CFLAGS'] + ' -Wp,-D_GLIBCXX_ASSERTIONS'
        env['LDFLAGS'] = '-Wl,-O1,--sort-common,--as-needed,-z,relro,-z,now'
        env['LTOFLAGS'] = '-flto=auto'
        env['MAKEFLAGS'] = '-j20'
        env['RUSTFLAGS'] = '-C link-args=-s -C target-cpu=native'

    return env, mold


def run_cmds(cmds):
    for cmd in cmds:
        subprocess.check_call(cmd)


def setup_groups():
    if GROUP_NAME.encode() in subprocess.check_output(['pueue', 'group']):
        run_cmds((
            ['pueue', 'kill', '-g', GROUP_NAME],
            ['pueue', 'clean', '-g', GROUP_NAME],
        ))

        import time
        time.sleep(1)

        import json
        out = json.loads(
            subprocess.check_output(['pueue', 'status', '-j', '-g', GROUP_NAME])
        )['tasks']

        for (id, obj) in out.items():
            subprocess.check_call(['pueue', 'remove', id])

        time.sleep(0.5)

        run_cmds((
            ['pueue', 'kill', '-g', GROUP_NAME],
            ['pueue', 'clean', '-g', GROUP_NAME],
            ['pueue', 'group', 'remove', GROUP_NAME],
        ))

    import math
    cores = math.ceil(len(os.sched_getaffinity(0)) / 4)

    run_cmds((
        ['pueue', 'group', 'add', GROUP_NAME],
        ['pueue', 'parallel', '-g', GROUP_NAME, str(cores)],
    ))


def wait_and_clean():
    run_cmds((
        ['pueue', 'wait', '-g', GROUP_NAME],
        ['pueue', 'clean', '-g', GROUP_NAME],
        ['pueue', 'group', 'remove', GROUP_NAME],
    ))


def install(force: bool):
    pkgs = get_packages()
    (env, is_mold) = get_run_info()

    validate_pueue()
    setup_groups()
    for pkg in pkgs:
        subprocess.check_call(pkg.args(is_mold, force), env=env)
    wait_and_clean()


def main():
    import argparse

    parser = argparse.ArgumentParser(
        prog='Cargo Packages',
        description='Installs our wanted rust applications'
    )

    parser.add_argument('-f', '--force', action='store_true',
                        help='force install via cargo')

    args = parser.parse_args()
    install(args.force)


class PkgInfo:
    def __init__(
            self,
            pkg: str,
            use_defaults: bool = True,
            nightly: bool = False,
            features: Optional[list[str]] = None
    ):
        self.pkg = pkg
        self.use_defaults = use_defaults
        self.nightly = nightly

        if features is None:
            self.features = []
        else:
            self.features = sorted(features)

    def __repr__(self):
        pkgs = ''
        if len(self.features) > 0:
            pkgs = '; ' + ', '.join(self.features)

        ndef = ''
        if not self.use_defaults:
            if pkgs != '':
                pkgs = '; '

            ndef = '(no defaults)'

        return f'PkgInfo({self.pkg}{pkgs}{ndef})'

    def args(self, mold: bool, force: bool) -> list[str]:
        a = [
            'pueue',
            'add',
            '--group', GROUP_NAME,
            '--label', self.pkg,
        ]

        if mold:
            a.extend(('mold', '--run'))

        a.append('cargo')
        if self.nightly:
            a.append('+nightly')
        a.extend(('install', self.pkg))

        if not self.use_defaults:
            a.append('--no-default-features')

        if len(self.features) > 0:
            a.append('--features')
            a.append(','.join(self.features))

        if force:
            a.append('--force')

        return a


def get_packages() -> list[PkgInfo]:
    want = [
        PkgInfo('b3sum'),
        PkgInfo('bacon'),
        PkgInfo('bat'),
        PkgInfo('bingrep'),
        PkgInfo('blake2_bin'),
        PkgInfo('broot'),
        PkgInfo('cargo-edit'),
        PkgInfo('cargo-geiger'),
        PkgInfo('cargo-generate'),
        PkgInfo('cargo-outdated'),
        PkgInfo('cargo-update'),
        PkgInfo('coreutils'),
        PkgInfo('csview'),
        PkgInfo('difftastic'),
        PkgInfo('du-dust'),
        PkgInfo('fd-find'),
        PkgInfo('fse_dump'),
        PkgInfo('git-delta'),
        PkgInfo('gitoxide'),
        PkgInfo('gping'),
        PkgInfo('hexyl'),
        PkgInfo('ht'),
        PkgInfo('https'),
        PkgInfo('igrep'),
        PkgInfo('jless'),
        PkgInfo('jsonxf'),
        PkgInfo('just'),
        PkgInfo('lsd'),
        PkgInfo('mdcat'),
        PkgInfo('nu'),
        PkgInfo('ouch'),
        PkgInfo('procs'),
        PkgInfo('ptail'),
        PkgInfo('ripgrep', features=['pcre2']),
        PkgInfo('sd'),
        PkgInfo('simple-http-server'),
        PkgInfo('tokei', features=['all']),
        PkgInfo('topgrade'),
        PkgInfo('wasm-pack'),
        PkgInfo('watchexec-cli'),
        PkgInfo('xsv'),
        PkgInfo('zoxide'),
    ]

    nix_pkgs = [
        PkgInfo('atuin', use_defaults=False, features=['client']),
        PkgInfo('bandwhich'),
        PkgInfo('bottom'),
        PkgInfo('exa'),
        PkgInfo('xcp'),
        PkgInfo('zellij'),
    ]

    win_pkgs = [
        PkgInfo('pueue'),
    ]

    gui_pkgs = [
        PkgInfo('czkawka_gui'),
    ]

    server_pkgs = [
        PkgInfo('czkawka_cli'),
    ]

    if is_nix():
        want.extend(nix_pkgs)

        sess = os.getenv('XDG_SESSION_TYPE')
        if sess is None or sess != 'wayland':
            want.extend(server_pkgs)
        else:
            want.extend(gui_pkgs)

    elif is_dar():
        want.extend(nix_pkgs)
        want.extend(gui_pkgs)

    elif is_win():
        want.extend(win_pkgs)
        want.extend(gui_pkgs)

    else:
        raise RuntimeError('Weird platform? ' + platform.system())

    return sorted(want, key=lambda x: x.pkg)


def is_win():
    return platform.system() == 'Windows'


def is_dar():
    return platform.system() == 'Darwin'


def is_nix():
    return platform.system() == 'Linux'


if __name__ == '__main__':
    main()
