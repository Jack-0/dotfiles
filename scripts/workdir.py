#!/usr/bin/env python3
# workdir.py
# Create git worktrees and switch to them in tmux
#
# Requirements:
# 1. brew install fzf
# 2. Must be run from within a git repository

import subprocess
import sys
import os
import argparse
from pathlib import Path

WORKDIR_BASE = Path.home() / "dev"


def get_git_root():
    """Get the root directory of the current git repository."""
    result = subprocess.run(
        ["git", "rev-parse", "--show-toplevel"],
        capture_output=True, text=True
    )
    if result.returncode != 0:
        print("Error: Not in a git repository")
        sys.exit(1)
    return Path(result.stdout.strip())


def get_repo_name():
    """Get the repository name from remote origin URL."""
    result = subprocess.run(
        ["git", "config", "--get", "remote.origin.url"],
        capture_output=True, text=True
    )
    if result.returncode != 0:
        print("Error: No remote origin configured")
        sys.exit(1)

    url = result.stdout.strip()
    # Handle both SSH (git@github.com:user/repo.git) and HTTPS URLs
    repo_name = url.rstrip("/").split("/")[-1]
    if repo_name.endswith(".git"):
        repo_name = repo_name[:-4]
    return repo_name


def get_branches():
    """Fetch and return all local and remote branches."""
    # Fetch latest from remotes
    subprocess.run(["git", "fetch", "--all"], capture_output=True)

    # Get all branches (local and remote)
    result = subprocess.run(
        ["git", "branch", "-a", "--format=%(refname:short)"],
        capture_output=True, text=True
    )
    if result.returncode != 0:
        print("Error: Failed to get branches")
        sys.exit(1)

    branches = result.stdout.strip().split("\n")
    # Clean up remote branch names (origin/branch -> branch)
    cleaned = set()
    for branch in branches:
        if branch.startswith("origin/"):
            branch = branch[7:]  # Remove "origin/" prefix
        if branch and branch != "HEAD":
            cleaned.add(branch)
    return sorted(cleaned)


def fzf_select(items):
    """Use fzf to select from a list of items."""
    items_str = "\n".join(items)
    result = subprocess.run(
        ["fzf", "--prompt=Select branch: "],
        input=items_str,
        capture_output=True, text=True
    )
    if result.returncode != 0 or not result.stdout.strip():
        return None
    return result.stdout.strip()


def worktree_exists(worktree_path):
    """Check if a worktree already exists at the given path."""
    return worktree_path.exists()


def prune_stale_worktrees(git_root):
    """Prune worktrees where the directory has been deleted."""
    subprocess.run(
        ["git", "worktree", "prune"],
        cwd=git_root,
        capture_output=True
    )


def create_worktree(git_root, branch, worktree_path, from_master=False):
    """Create a git worktree for the given branch."""
    # Check if branch exists locally
    local_check = subprocess.run(
        ["git", "show-ref", "--verify", f"refs/heads/{branch}"],
        capture_output=True
    )
    local_exists = local_check.returncode == 0

    # Check if branch exists on remote
    remote_check = subprocess.run(
        ["git", "show-ref", "--verify", f"refs/remotes/origin/{branch}"],
        capture_output=True
    )
    remote_exists = remote_check.returncode == 0

    if local_exists:
        # Branch exists locally, create worktree from it
        result = subprocess.run(
            ["git", "worktree", "add", str(worktree_path), branch],
            cwd=git_root
        )
    elif remote_exists:
        # Branch exists on remote, track it
        result = subprocess.run(
            ["git", "worktree", "add", "--track", "-b", branch,
             str(worktree_path), f"origin/{branch}"],
            cwd=git_root
        )
    elif from_master:
        # New branch from origin/master
        subprocess.run(["git", "fetch", "origin", "master"], cwd=git_root)
        result = subprocess.run(
            ["git", "worktree", "add", "-b", branch,
             str(worktree_path), "origin/master"],
            cwd=git_root
        )
    else:
        # New branch, create from current HEAD
        result = subprocess.run(
            ["git", "worktree", "add", "-b", branch, str(worktree_path)],
            cwd=git_root
        )

    return result.returncode == 0


def in_tmux():
    """Check if we're running inside tmux."""
    return "TMUX" in os.environ


def tmux_session_exists(session_name):
    """Check if a tmux session with the given name exists."""
    result = subprocess.run(
        ["tmux", "has-session", "-t", session_name],
        capture_output=True
    )
    return result.returncode == 0


def switch_to_tmux_session(session_name, directory, code_review=False):
    """Create and/or switch to a tmux session for the worktree."""
    session_name = session_name.replace(".", "_")
    claude_cmd = 'claude "Perform a code review using this branch in comparison to master"'

    session_existed = tmux_session_exists(session_name)

    if not session_existed:
        if code_review:
            # Create session with claude code review command
            subprocess.run([
                "tmux", "new-session", "-ds", session_name,
                "-c", str(directory), claude_cmd
            ])
        else:
            subprocess.run([
                "tmux", "new-session", "-ds", session_name,
                "-c", str(directory)
            ])
    elif code_review:
        # Session exists, create new window at index 0 with claude command
        subprocess.run([
            "tmux", "new-window", "-t", f"{session_name}:0",
            "-c", str(directory), "-b", claude_cmd
        ])

    if in_tmux():
        subprocess.run(["tmux", "switch-client", "-t", session_name])
    else:
        subprocess.run(["tmux", "attach-session", "-t", session_name])

    print(f'Attached to "{session_name}"')


def main():
    parser = argparse.ArgumentParser(
        description="Create git worktrees and switch to them in tmux"
    )
    parser.add_argument(
        "-b", "--branch",
        help="Create a new branch from current HEAD"
    )
    parser.add_argument(
        "-bm", "--branch-from-master",
        help="Create a new branch from origin/master"
    )
    parser.add_argument(
        "-cr", "--code-review",
        action="store_true",
        help="Open tmux session with claude code review prompt"
    )
    args = parser.parse_args()

    git_root = get_git_root()
    repo_name = get_repo_name()
    from_master = False

    if args.branch_from_master:
        branch = args.branch_from_master
        from_master = True
    elif args.branch:
        branch = args.branch
    else:
        branches = get_branches()
        if not branches:
            print("Error: No branches found")
            sys.exit(1)
        branch = fzf_select(branches)
        if not branch:
            sys.exit(0)

    # Worktree path: ~/dev/<repo_name>-<branch>
    worktree_name = f"{repo_name}-{branch}"
    worktree_path = WORKDIR_BASE / worktree_name

    # Prune stale worktrees (deleted directories git still tracks)
    prune_stale_worktrees(git_root)

    if worktree_exists(worktree_path):
        print(f"Worktree already exists at {worktree_path}")
    else:
        WORKDIR_BASE.mkdir(parents=True, exist_ok=True)
        if not create_worktree(git_root, branch, worktree_path, from_master):
            print(f"Error: Failed to create worktree for branch '{branch}'")
            sys.exit(1)
        print(f"Created worktree at {worktree_path}")

    switch_to_tmux_session(worktree_name, worktree_path, args.code_review)


if __name__ == "__main__":
    main()
