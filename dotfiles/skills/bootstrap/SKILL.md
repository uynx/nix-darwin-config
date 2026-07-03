---
name: bootstrap
description: Mandatory startup initialization. Run this skill first on session start to initialize the reasoning-trace and base memory context.
---

# Session Startup Bootstrap

To initialize the session properly, you MUST execute the following operations in your first turn:

1. **Reasoning Trace Activation**:
   * Set your reasoning-trace dial to `wenyan-ultra` by calling:
     `/caveman reasoning wenyan-ultra`
   * *Note*: This applies ONLY to your internal thinking tags, never to user-facing text.

2. **Context Seeding**:
   * View the root index of your memory vault:
     Read `/Users/uynx/ai_memory/index.md`
   * View the core caveman rule sheet to align internal reasoning constraints:
     Read `/Users/uynx/.agents/skills/caveman/SKILL.md`
