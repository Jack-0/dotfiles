#!/usr/bin/env python3
# sesh.sh
# Create a tmux session for ssh
#
# Requirements
# 1. brew install fzf
# 2. change 'sshHostCmd' as required
sshHostsCmd = {
    "host1": "ssh user1@host1",
    "host2": "ssh user2@host2",
    "todo": "change me",
}

import subprocess
import os

def inTmux():
    return "TMUX" in os.environ

def tmuxSeshExists(sessionName):
    return subprocess.run(['tmux', 'has-session', '-t', sessionName]).returncode == 0


def tmuxAttach(sessionName):
    if inTmux():
        return subprocess.run(['tmux', 'switch-client', '-t', sessionName])
    else:    
        return subprocess.run(['tmux', 'attach-session', '-t', sessionName])
 
def createSession(name, cmd):
    print("create")
    subprocess.run(['tmux', 'new-session', '-d', '-s', name, cmd])
    tmuxAttach(name)


def startTmuxSSHSession(name, cmd):
    if tmuxSeshExists(name):
        print("a")
        tmuxAttach(name)
    else:
        print("b")
        createSession(name, cmd)

if __name__ == "__main__":
    # get seesion
    names = list(sshHostsCmd)
    namesStr = '\n'.join([''.join(n) for n in names])

    # pipe into fzf and get selected 
    echo = subprocess.run(['echo', namesStr], stdout=subprocess.PIPE, text=True)
    output = echo.stdout
    fzf = subprocess.run(['fzf'], input=output, stdout=subprocess.PIPE, text=True)
    selected = fzf.stdout
    selected = selected.strip()

    startTmuxSSHSession(selected, sshHostsCmd[selected])
