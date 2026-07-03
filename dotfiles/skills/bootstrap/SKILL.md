---
name: bootstrap
description: Mandatory startup initialization. Run this skill first on session start to initialize the reasoning-trace and base memory context.
---

# Session Startup Bootstrap

To initialize the session properly, you MUST execute the following operations in your first turn:

1. **Caveman & Reasoning Activation**:
   * Set your visible-reply dial to `full` (caveman default) by calling:
     `/caveman full`
   * Set your reasoning-trace dial to `wenyan-ultra` (ultra Chinese reasoning) by calling:
     `/caveman reasoning wenyan-ultra`

2. **Context Seeding**:
   * View the root index of your memory vault:
     Read `/Users/uynx/ai_memory/index.md`
   * View the core caveman rule sheet to align internal reasoning constraints:
     Read `/Users/uynx/.agents/skills/caveman/SKILL.md`
