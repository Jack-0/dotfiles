#!/usr/bin/env python3
import subprocess
import os
import tomllib
from pathlib import Path
# sesh.sh
# Create a tmux session for ssh
#
# Requirements
# 1. brew install fzf
# 2. alter config.toml (you may need to "cp config.toml.example config.toml")


def inTmux():
    return "TMUX" in os.environ


def tmuxSeshExists(sessionName):
    return subprocess.run(
        ['tmux', 'has-session', '-t', sessionName]
    ).returncode == 0


def tmuxAttach(sessionName):
    if inTmux():
        return subprocess.run(['tmux', 'switch-client', '-t', sessionName])
    else:
        return subprocess.run(['tmux', 'attach-session', '-t', sessionName])


def createSession(name, cmd):
    subprocess.run(['tmux', 'new-session', '-d', '-s', name, cmd])
    tmuxAttach(name)


def startTmuxSSHSession(name, cmd):
    if tmuxSeshExists(name):
        tmuxAttach(name)
    else:
        createSession(name, cmd)


if __name__ == "__main__":
    # current_dir = Path(__file__).parent
    current_dir = Path(__file__).resolve().parent
    config_file_path = current_dir.name + "/../config.toml"
    with open(config_file_path, "rb") as f:
        data = tomllib.load(f)
    sshHostInfo = data["ssh"]

    # get seesion
    names = [entry["name"] for entry in sshHostInfo]
    namesStr = '\n'.join([''.join(n) for n in names])

    # pipe into fzf and get selected
    echo = subprocess.run(['echo', namesStr],
                          stdout=subprocess.PIPE, text=True)
    output = echo.stdout
    fzf = subprocess.run(['fzf'], input=output,
                         stdout=subprocess.PIPE, text=True)
    selected_name = fzf.stdout
    selected_name = selected_name.strip()

    # find next entry with selected name
    selected_ssh_info = next(
        (entry for entry in sshHostInfo
            if entry["name"].strip() == selected_name), None)

    if selected_name is None or selected_name == "":
        exit()

    if selected_ssh_info is None:
        raise Exception(selected_name, "Not found in ssh hosts list")

    startTmuxSSHSession(selected_name, selected_ssh_info["cmd"])
