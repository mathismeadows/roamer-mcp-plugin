---
name: bug
description: Eight-step gated bug fix workflow — understand before concluding, propose fix, update spec, test, commit with approval at each step
argument-hint: "[bug description]"
allowed-tools: ["Read", "Write", "Edit", "Bash", "Glob", "Grep", "Agent", "AskUserQuestion", "mcp__roamer__get_registry", "mcp__roamer__get_project", "mcp__roamer__get_spec_area", "mcp__roamer__get_spec_item", "mcp__roamer__log_spec_item", "mcp__roamer__update_project", "mcp__roamer__resolve_blocker"]
disable-model-invocation: true
---

A bug has been described above. Follow these steps exactly and do not proceed to the next step without explicit approval.

STEP 1 — Read context
Read resource roamer://brain/overview.md and identify which product the affected project belongs to.
Call get_registry(projectNames: <that product's project list>) for cross-project state and open blockers scoped to the affected product, not the whole ecosystem. If the project isn't part of any known product, pass just its own name.
Call get_project for the affected project.
Call get_spec_area for the relevant spec areas (use list_specs first if needed).

STEP 2 — Understand before concluding
Read all code relevant to the reported bug.
Do not form conclusions yet.

Answer these questions only:
- What does the spec say the behaviour should be?
- What does the code actually do?
- Where exactly does the code diverge from the spec?
- Is this a spec gap, a code bug, or both?
- What platforms are affected?
- What is the blast radius — what else could be affected?

Show me your findings. Wait for my approval before proposing any fix.

STEP 3 — Propose fix
Propose the minimal fix that makes the code match the spec. Do not refactor beyond what is necessary.

If the spec is wrong or incomplete, propose the spec change first and explain why.

Show me exactly what you plan to change.
Wait for my approval before touching any code.

STEP 4 — Update spec if needed
If the bug revealed a spec gap, call log_spec_item to write the missing spec item before fixing the code.
Use the next available ID in the affected area.
Note which platforms are affected.
Show me the spec change. Wait for approval.

STEP 5 — Implement fix
Make the minimal code change approved in Step 3.
Do not change anything not directly related to the bug.
After each file confirm what was written.

STEP 6 — Tests
Write a test that:
- Reproduces the bug (fails before the fix)
- Proves the fix works (passes after)
- Prevents regression

Follow existing test structure and naming conventions.
Add fixture data if needed.
Mirror across iOS and macOS if both platforms affected.
Add accessibility identifiers for any UI elements involved.

STEP 7 — Record state
Record the fix and any related gaps this revealed via update_project (close what is done; note new gaps with the relevant spec IDs). If it resolves a cross-project blocker, call resolve_blocker.

STEP 8 — Commit
One commit per repo touched.
Commit message format:
fix([AREA-ID]): brief description of bug and fix

Full explanation:
- What the bug was
- Why it happened
- What the fix does
- Why this approach and not another
Spec: [spec file and item IDs]
Tests: [test class and method names]

Show me all commit messages before committing.
Wait for my approval.
