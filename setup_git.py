#!/usr/bin/env python

import argparse
import subprocess
import time
import typing

from pathlib import Path

type torun = dict[str, set[typing.Any]]


allowed_signers_file = Path(__file__).resolve().parent / "allowed_git_signers"


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


def add_sig(email: str, key: str):
    want = f"{email} {key}"

    if allowed_signers_file.exists():
        known = allowed_signers_file.read_text().splitlines()
        if want not in known:
            known.append(want)
            known.sort()
            allowed_signers_file.write_text("\n".join(known) + "\n")
    else:
        allowed_signers_file.write_text(want + "\n")


def setup(d: torun, email: str, signingKey: str, rewrites: dict[str, str]):
    t = "true"
    f = "false"

    if signingKey != "":
        add_sig(email, signingKey)
        sig_key = "key::" + signingKey
    else:
        sig_key = ""

    add_cmds(d, "apply", whitespace="strip")
    add_cmds(d, "branch", sort="-committerdate")
    add_cmds(d, "commit", gpgSign=str(signingKey != "").lower(), rebase=t)
    add_cmds(d, "core", autocrlf=f, editor="nvim", pager="delta")
    add_cmds(d, "difftool", prompt="false")
    add_cmds(d, "difftool.difftastic", cmd='difft "$LOCAL" "$REMOTE"')
    add_cmds(d, "fetch", prune=t)
    add_cmds(d, "gpg", format="ssh")
    add_cmds(d, "gpg.ssh", allowedSignersFile=str(allowed_signers_file))
    add_cmds(d, "init", defaultBranch="main")
    add_cmds(d, "interactive", diffFilter="delta --color-only --features=interactive")
    add_cmds(d, "log", date="iso")
    add_cmds(d, "merge", conflictstyle="zdiff3", keepbackup=f, tool="nvim")
    add_cmds(d, "pager", difftool=t)
    add_cmds(d, "pull", rebase=f)
    add_cmds(d, "push", default="current", followTags=t)
    add_cmds(d, "rebase", autosquash=t, autostash=t, updateRefs=t)
    add_cmds(d, "rerere", enabled=t)
    add_cmds(d, "submodule", recurse=t)
    add_cmds(d, "user", name="Adam Lesperance", email=email, signingKey=sig_key)

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
        side_by_side=f,
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

    if rewrites:
        add_cmds(d, "url", **rewrites)


def main(email: str, signingKey: str, rewrites: dict[str, str]):
    d: torun = dict()
    setup(d, email, signingKey, rewrites)
    run(d)


def def_key() -> str:
    try:
        out = subprocess.check_output(["ssh-add", "-L"]).decode("utf-8").splitlines()
        out = [line.strip() for line in out if line.strip() != ""]
        if len(out) > 0:
            if len(out) > 1:
                print("\n\n\nMultiple keys found in ssh-add\n\n\n")
                time.sleep(3)
            return out[0]
        return ""
    except subprocess.CalledProcessError:
        return ""


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Applies global git settings")
    parser.add_argument("-e", "--email", default="lespea@gmail.com")
    parser.add_argument("-k", "--key", default=def_key())
    parser.add_argument("--rm", action=argparse.BooleanOptionalAction, default=False)
    parser.add_argument("-r", "--rewrite", nargs="*", default=["!github.com"])

    args = parser.parse_args()

    if args.rm:
        (Path.home() / ".gitconfig").unlink(missing_ok=True)

    rewrites = {}
    if args.rewrite is not None:
        for urll in args.rewrite:
            for url in urll.split(","):
                if url != "":
                    if url.startswith("!"):
                        action = "pushInsteadOf"
                        url = url[1:]
                    else:
                        action = "insteadOf"

                    rewrites[f"ssh://git@{url}/.{action}"] = f"https://{url}/"

    main(args.email, args.key, rewrites)
