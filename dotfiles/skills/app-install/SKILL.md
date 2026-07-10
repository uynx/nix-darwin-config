---
name: app-install
description: Use this skill when installing, searching, or configuring applications or packages on macOS.
---

# App Install Policy

All software installs must be handled declaratively through `~/nix-config/`. Do not perform manual downloads, App Store installs, or direct CLI installations (like manual brew runs) unless absolutely unavoidable.

## Decision Matrix for Installations

1. **Check Nixpkgs First**:
   * Search for `aarch64-darwin` compatibility:
     ```bash
     nix search nixpkgs <name>
     ```
   * If the package is available and compatible, add it to `home.packages` in `/Users/uynx/nix-config/home.nix`.

2. **Nixpkg Not Available / Incompatible**:
   * If there is no `aarch64-darwin` package, use Homebrew via `/Users/uynx/nix-config/darwin.nix`.
   * **CLI Tools**: Add to `homebrew.brews`.
   * **GUI Applications**: Add to `homebrew.casks`.

3. **Fast-Moving AI Apps Exception**:
   * For applications that undergo rapid updates and are prone to breaking under pinned Nix versions (e.g., Claude, Cursor, ChatGPT, Antigravity):
   * **Rule**: ALWAYS install via Homebrew Cask in `darwin.nix`, even if a Nix package exists.

## Rebuild Workflow
* After editing `.nix` configuration files, run the `Nix-Darwin Config Rebuild` skill to check, commit, and push the configuration.
* Instruct the user to run the `reb` alias to build and activate the new configuration.
