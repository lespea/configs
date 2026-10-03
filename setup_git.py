#!/usr/bin/env python

import argparse
import os
import shutil
import subprocess
import time
import typing
from pathlib import Path

type ToRun = dict[str, set[typing.Any]]


repo_dir = Path(__file__).resolve().parent
allowed_signers_file = repo_dir / "allowed_git_signers"
delta_themes_file = repo_dir / "delta-themes.gitconfig"


def global_config() -> Path:
    return Path(os.environ.get("GIT_CONFIG_GLOBAL", Path.home() / ".gitconfig"))


def run(d: ToRun, dry_run: bool):
    keys = sorted(d.keys())
    for k in keys:
        print(f"Adding {k}")
        arg_list = sorted(d[k])
        for args in arg_list:
            args = list(args)
            print("  " + " ".join(args))
            if not dry_run:
                subprocess.check_call(args=args)


def setup_gh_credentials(dry_run: bool):
    # Auth to GitHub over https with gh's token instead of ssh keys. Same entries as
    # `gh auth setup-git`, but that writes gh's resolved path, which mise changes on upgrade.
    if shutil.which("gh") is None:
        print("gh not installed; skipping the GitHub credential helper")
        return
    print("Adding credential")
    for host in ["github.com", "gist.github.com"]:
        key = f"credential.https://{host}.helper"
        cmds = [
            ["git", "config", "--global", "--unset-all", key],
            ["git", "config", "--global", "--add", key, ""],
            ["git", "config", "--global", "--add", key, "!gh auth git-credential"],
        ]
        for cmd in cmds:
            print("  " + " ".join(cmd))
            if not dry_run:
                # --unset-all exits 5 when there's nothing to unset
                subprocess.run(cmd, check=cmd[3] != "--unset-all")
    if (
        subprocess.run(
            ["gh", "auth", "status"], capture_output=True, check=False
        ).returncode
        != 0
    ):
        print("gh is not logged in yet; run `gh auth login`")


def add_cmds(d: ToRun, base: str, **defs: str):
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


def setup(d: ToRun, email: str, signingKey: str, rewrites: dict[str, str]):
    t = "true"
    f = "false"

    if signingKey != "":
        add_sig(email, signingKey)
        sig_key = "key::" + signingKey
    else:
        sig_key = ""

    add_cmds(d, "apply", whitespace="strip")
    add_cmds(d, "branch", sort="-committerdate")
    add_cmds(d, "column", ui="auto")
    add_cmds(d, "commit", gpgSign=str(signingKey != "").lower(), verbose=t)
    add_cmds(d, "core", autocrlf=f, editor="nvim", pager="delta")
    add_cmds(d, "difftool", prompt="false")
    add_cmds(d, "difftool.difftastic", cmd='difft "$LOCAL" "$REMOTE"')
    add_cmds(d, "fetch", prune=t)
    add_cmds(d, "gpg", format="ssh")
    add_cmds(d, "gpg.ssh", allowedSignersFile=str(allowed_signers_file))
    add_cmds(d, "help", autocorrect="prompt")
    add_cmds(d, "include", path=str(delta_themes_file))
    add_cmds(d, "init", defaultBranch="main")
    add_cmds(d, "interactive", diffFilter="delta --color-only")
    add_cmds(d, "log", date="iso")
    add_cmds(d, "merge", conflictstyle="zdiff3", tool="nvimdiff")
    add_cmds(d, "mergetool", keepBackup=f)
    add_cmds(d, "pager", difftool=t)
    add_cmds(d, "pull", rebase=f)
    add_cmds(d, "push", autoSetupRemote=t, default="current", followTags=t)
    add_cmds(d, "rebase", autosquash=t, autostash=t, updateRefs=t)
    add_cmds(d, "rerere", autoUpdate=t, enabled=t)
    add_cmds(d, "submodule", recurse=t)
    add_cmds(d, "tag", sort="version:refname")
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
        dlog='!f() { GIT_EXTERNAL_DIFF=difft git log -p --ext-diff "$@"; }; f',
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
        pager=t,
        status=t,
        ui="auto",
    )

    add_cmds(
        d,
        "delta",
        features="token-meridian-dark",
        line_numbers=t,
        navigate=t,
        side_by_side=f,
    )

    add_cmds(
        d,
        "diff",
        algorithm="histogram",
        colorMoved="default",
        renames="copy",
        tool="difftastic",
    )

    if rewrites:
        add_cmds(d, "url", **rewrites)


# Keys earlier versions of this script set, removed so a run without --rm doesn't leave
# them behind (add_cmds can only set values).
stale_keys = [
    "color.diff",
    "color.grep",
    "color.interactive",
    "commit.rebase",
    "delta.syntax-theme",
    "diff.rename",
    "merge.keepbackup",
]


def remove_stale(dry_run: bool):
    print("Removing stale")
    for key in stale_keys:
        cmd = ["git", "config", "--global", "--unset-all", key]
        print("  " + " ".join(cmd))
        if not dry_run:
            # exits 5 when the key isn't set
            subprocess.run(cmd, check=False)


def main(email: str, signingKey: str, rewrites: dict[str, str], dry_run: bool):
    d: ToRun = {}
    setup(d, email, signingKey, rewrites)
    remove_stale(dry_run)
    run(d, dry_run)
    setup_gh_credentials(dry_run)


def cleanup_key(key: str) -> str:
    parts = key.strip().split()
    if len(parts) != 3:
        raise ValueError(f"Invalid key: {key}")
    return f"{parts[0]} {parts[1]}"


def def_key() -> str:
    try:
        out = subprocess.check_output(["ssh-add", "-L"]).decode("utf-8").splitlines()
        out = [cleanup_key(line) for line in out if line.strip() != ""]
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
    parser.add_argument(
        "-k",
        "--key",
        help="ssh public key to sign with (default: first key in ssh-add -L)",
    )
    parser.add_argument(
        "--rm",
        action=argparse.BooleanOptionalAction,
        default=False,
        help="delete the global gitconfig first, so it only has what this script sets",
    )
    parser.add_argument(
        "-r",
        "--rewrite",
        nargs="*",
        default=[],
        help="hosts to reach over ssh instead of https; prefix with ! to only rewrite pushes",
    )
    parser.add_argument(
        "-n",
        "--dry-run",
        action="store_true",
        help="print the commands without running them",
    )

    args = parser.parse_args()

    if args.rm and not args.dry_run:
        global_config().unlink(missing_ok=True)

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

    key = args.key if args.key is not None else def_key()
    main(args.email, key, rewrites, args.dry_run)
