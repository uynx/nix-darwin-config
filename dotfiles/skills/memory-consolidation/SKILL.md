---
name: memory-consolidation
description: Use this skill when executing the memory consolidation protocol, compiling daily journal nodes, organizing concepts, pruning the index, or syncing the ai_memory vault.
---

# Memory Consolidation Skill

Follow these rules when writing to, editing, or synchronizing the `/Users/uynx/ai_memory/` vault.

## 1. Vault Formatting & Style Guide (Mandatory Caveman)
* **HTML Wrapper**: Main content MUST be wrapped in `<article>`.
  * Hierarchy: `<header>` for title/description, `<section id="...">` for subsections.
  * Links & Metadata: Put Obsidian `[[wikilinks]]` outside/after the `</article>` wrapper.
* **Caveman Tone**: Skill `/caveman` (default level) MUST be active for every memory edit (journal, concepts, `index.md`). Disable when done.
* **Terseness**: Write dense, fragment-heavy prose. No articles ("the/a/an") or filler words.
* **Scope**: These formatting rules also apply to `AGENTS.md` itself when edited.
* **Clickable file:/// Links**: When documenting modifications to codebase or configuration files in journals or concepts, always use clickable `file:///` links (e.g., `[filename](file:///path/to/file)`). Do not document changes with plain text paths.
* **Wikilink Scope Limits**: Never use Obsidian wikilinks `[[filename]]` for files located outside the `/Users/uynx/ai_memory/` vault. For external files (such as files in `~/nix-config/` or local configurations), use standard markdown `file:///` links or inline code formatting.

## 2. Proactive Logging Protocol
* **Trigger**: Only compile a daily journal node if the session directly relates to an active project. For general Q&As or general advice, DO NOT log or write to `/Users/uynx/ai_memory/`.
* **Back-linking**: Append links after the `</article>` wrapper:
  ```markdown
  **Prev**: `[[{project_name}_YYYY-MM-DD_of_previous_log]]`
  **Parent**: `[[{project_name}]]`
  ```
* **Pointer Update**: Update the overview concept node to point to the new daily node.
* **Index Pruning**: Keep the `Recent Journal Logs` section in `/Users/uynx/ai_memory/index.md` capped at the 10 most recent entries. Prune older links.
* **Worthiness Filter**: Ask: "Does this move the goal forward or matter next time?" If not, discard.

## 3. Topic Creation & Edge Construction
* **Cross-Project Linking**: For overlapping tasks, add wikilinks at the bottom (`**Overlap**: [[link]]`).
* **Concepts**: Create new nodes in `/Users/uynx/ai_memory/concepts/` (using HTML wrapper format) and list them in the index.
* **Safety & Suffixes**: Note source URLs/citations for configs/medical info. Resolve collisions with suffixes (e.g., `performance_nix`).

## 4. Vault Synchronization
* **Command**: Run `memory-sync "<message>"` to commit and push changes.
* **Messages**: Use normal, succinct English for the commit message (e.g., `memory-sync "Journal: Log daily progress for Nix Darwin Setup"`). No generic fallback messages.
