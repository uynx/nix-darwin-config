---
name: "Nix-Darwin Config Rebuild"
description: "Automatically verify, commit, and push Mac Nix-Darwin system configuration changes, and instruct the user to rebuild."
---

# Nix-Darwin Config Rebuild Skill

Use this skill when nix-darwin or home-manager configuration files under `/Users/uynx/nix-config/` have been modified and need to be built and activated.

## When to Trigger
- Trigger this skill automatically after modifying `.nix` configuration files in the workspace.
- Can be manually invoked by saying "rebuild nix config" or similar.
- **Note**: Modifying `AGENTS.md` does not require a rebuild (`reb`) because it is symlinked; changes take effect immediately.

## Action Steps
1. **Verify Syntax**: Run `nix flake check` to verify configuration syntax:
   ```bash
   nix flake check --no-build /Users/uynx/nix-config
   ```
2. **Local Commit**: If the syntax check passes, stage the changes and create a local commit on your working branch (do not push immediately if the task is ongoing):
   ```bash
   git add .
   git commit -m "<concise_message>"
   ```
3. **Verify, Squash, and Push**: Once the task is fully complete and verified:
   * Rebase on top of the latest main changes: `git pull --rebase origin main`
   * Squash history programmatically (since the agent runs in a non-interactive shell):
     * *Method A (Soft Reset - preferred):* Run `git reset --soft origin/main` (or the last upstream commit hash) to uncommit all local changes while keeping them staged, then run `git commit -m "clean descriptive message"`.
     * *Method B (Programmatic Rebase):* Run:
       ```bash
       GIT_SEQUENCE_EDITOR="sed -i '2,\$s/^pick/squash/'" git rebase -i origin/main
       ```
   * Push the cleaned commit to the remote branch and open/update the Pull Request to `main`.
4. **Instruct Rebuild**: Tell the user to run the rebuild alias to apply:
   ```bash
   reb
   ```
5. **Troubleshoot Failures**: If the user reports that `reb` failed:
   - Parse the compiler output or error logs.
   - Propose and implement a fix.
   - Run `nix flake check` again, auto-commit/push the fix, and prompt the user to run `reb` again.
