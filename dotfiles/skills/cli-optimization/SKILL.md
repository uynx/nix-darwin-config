---
name: cli-optimization
description: Selection logic for high-performance terminal commands on macOS (rg, fd, sd, eza, dash).
---

# CLI Tool Selection Protocol

Before executing search, traversal, file modification, or listing commands, follow this logic:

1. **Interpreter**
   * Use `dash` over `bash` for running POSIX-compliant shell scripts.

2. **Text Search**
   * Use `rg` (ripgrep) only. Never use standard `grep`.

3. **File Find / Traversal**
   * Use `fd` for large workspaces or when `.gitignore` compliance is needed.
   * Use standard `find` only for simple, targeted, or small directories.

4. **Find and Replace**
   * Use `sd` over `sed` for pattern replacement.

5. **File Read**
   * Use `cat` over `bat` for fast stdout dumps.

6. **Directory Listing**
   * Use standard `ls` for simple lists.
   * Use `eza` only when you specifically need git-status overlays or tree visualization.
