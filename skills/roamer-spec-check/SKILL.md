---
name: roamer-spec-check
description: RoamerMcp hygiene check — verify unit tests, TODOs, README, and MCP tool descriptions
allowed-tools: ["Read", "Glob", "Grep", "Bash"]
disable-model-invocation: true
---

Review changes made this session and check:
1. Do any unit tests need updating or creating?
2. Are there any TODOs introduced but not resolved?
3. Does the README need updating?
4. Does any MCP tool description need clarifying?

Output a checklist:
  ✅ no action needed
  ⚠️ should update
  ❌ missing — must create

Ask me which to fix now vs defer.
