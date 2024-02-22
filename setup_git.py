#!/usr/bin/env python

import argparse
import subprocess


type torun = dict[str, set[any]]


def run(d: torun):
    keys = sorted(d.keys())
    for k in keys:
        print(f"Adding {k}")
        arg_list = sorted(d[k])
        for args in arg_list:
            args = list(args)
            print("  " + " ".join(args))
            subprocess.check_call(args=args)


def add_cmds(d: torun, base: str, **defs: str):
    for k, v in defs.items():
        if v != "":
            k = k.replace("_", "-")
            args = (
                "git",
                "config",
                "--global",
                f"{base}.{k}",
                v,
            )
            d.setdefault(base, set()).add(args)


def setup(d: torun, email: str, signingKey: str):
    t = "true"
    f = "false"

    add_cmds(d, "apply", whitespace="strip")
    add_cmds(d, "branch", sort="-committerdate")
    add_cmds(d, "commit", gpgSign=str(signingKey != "").lower(), rebose=t)
    add_cmds(d, "core", autocrlf=f, editor="nvim", pager="delta")
    add_cmds(d, "difftool", prompt="false")
    add_cmds(d, "difftool.difftastic", cmd='difft "$LOCAL" "$REMOTE"')
    add_cmds(d, "fetch", prune=t, prunetags=t)
    add_cmds(d, "init", defaultBranch="main")
    add_cmds(d, "interactive", diffFilter="delta --color-only --features=interactive")
    add_cmds(d, "log", date="iso")
    add_cmds(d, "merge", conflictstyle="zdiff3", keepbackup=f, tool="nvim")
    add_cmds(d, "pager", difftool=t)
    add_cmds(d, "pull", rebase=f)
    add_cmds(d, "push", default="current", followtags=t)
    add_cmds(d, "rebase", autosquash=t, autostash=t, updateRefs=t)
    add_cmds(d, "rerere", enabled=t)
    add_cmds(d, "submodule", recurse=t)
    add_cmds(d, "user", name="Adam Lesperance", email=email, signingKey=signingKey)

    for b in ["transfer", "fetch", "receive"]:
        add_cmds(d, b, fsckobjects=t)

    add_cmds(
        d,
        "alias",
        aa="add -A",
        ca="commit -a",
        co="checkout",
        dt="difftool",
        dlog="!f() { GIT_EXTERNAL_DIFF=difft git log -p --ext-diff $@; }; f",
        gca="gc --aggressive",
        st="status",
    )

    add_cmds(
        d,
        "cola",
        fontdiff="Cascadia Code PL,12,-1,5,50,0,0,0,0,0",
        hidpi="1",
        icontheme="dark",
        spellcheck=f,
        startupmode="folder",
        theme="flat-dark-blue",
    )

    add_cmds(
        d,
        "color",
        diff="always",
        grep="always",
        interactive="always",
        pager=t,
        status=t,
        ui="always",
    )

    add_cmds(
        d,
        "delta",
        features="decorations",
        line_numbers=t,
        side_by_side=t,
        syntax_theme="Monokai Extended",
    )

    add_cmds(
        d,
        "diff",
        algorithm="patience",
        colorMoved="default",
        rename="copy",
        tool="difftastic",
    )


def main(email: str, signingKey: str):
    d: torun = dict()
    setup(d, email, signingKey)
    run(d)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Applies global git settings")
    parser.add_argument("-e", "--email", default="lespea@gmail.com")
    parser.add_argument(
        "-k", "--key", default="8062DB324D4405D656B07A91E57FA7C8B50DE252"
    )
    args = parser.parse_args()
    main(args.email, args.key)
