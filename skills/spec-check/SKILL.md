---
name: spec-check
description: End-of-session hygiene check — verify unit tests, TODOs, and docs stay in sync with this session's changes
allowed-tools: ["Read", "Glob", "Grep", "Bash"]
disable-model-invocation: true
---

Review changes made this session and check:
1. Do any unit tests need updating or creating?
2. Are there any TODOs introduced but not resolved?
3. Does the README (or ARCHITECTURE.md) need updating?
4. Does any public interface — API, CLI, config, or tool/prompt description — need clarifying documentation?

Output a checklist:
  ✅ no action needed
  ⚠️ should update
  ❌ missing — must create

Ask me which to fix now vs defer.
