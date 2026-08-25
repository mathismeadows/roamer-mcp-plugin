---
name: spec-audit
description: Audit spec coverage — compare spec items to test coverage and flag gaps
allowed-tools: ["Read", "Glob", "Grep", "mcp__roamer__list_specs", "mcp__roamer__get_spec_area"]
---

Read resource roamer://brain/overview.md to locate all spec and test files.

For each behavioral spec (call list_specs to enumerate them), call get_spec_area for each area and compare against the corresponding test files in the repo.

For each spec item report:
✅ test exists and matches spec
⚠️ test exists but doesn't fully match spec wording
❌ no test exists for this spec item
🆕 test exists with no corresponding spec item

Then give me a plain English summary of the biggest gaps — where spec and code have drifted the most.

Do not fix anything. Audit only.
Ask me which gaps to address before proceeding.
