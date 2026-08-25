---
name: feature
description: Seven-step gated feature workflow — spec first, plan, implement, test, cleanup, commit with approval at each step
argument-hint: "[feature description]"
allowed-tools: ["Read", "Write", "Edit", "Bash", "Glob", "Grep", "Agent", "AskUserQuestion", "mcp__roamer__get_registry", "mcp__roamer__get_project", "mcp__roamer__list_specs", "mcp__roamer__get_spec_area", "mcp__roamer__get_spec_item", "mcp__roamer__log_spec_item", "mcp__roamer__log_thread", "mcp__roamer__update_project"]
---

A new feature has been described above. Follow these steps exactly and do not proceed to the next step without explicit approval.

STEP 1 — Read context
Read resource roamer://brain/overview.md and identify which product the affected project belongs to.
Call get_registry(projectNames: <that product's project list>) for cross-project state and open blockers scoped to the affected product, not the whole workspace. If the project isn't part of any known product, pass just its own name.
Call get_project for the affected project's session history.
Call get_spec_area for the relevant spec areas (use list_specs first to find the right spec if needed).

STEP 2 — Update spec first
Identify which functional areas are affected.
Call log_spec_item for each new spec item, using the next available ID in each area.
Note which platform each behaviour applies to.
Show me every spec change before writing anything.
Wait for my approval before proceeding.

STEP 3 — Plan of work
Produce a precise implementation plan:
- Every file that needs changing and why
- Every new file needed
- Test cases required per new spec item
- Any cross-platform considerations
- Any cross-repo impact on other repos in the workspace, if any
- Any engineering threads to open via log_thread
Show me the plan. Wait for my approval before proceeding.

STEP 4 — Implement
Make every code change in the plan.
Follow existing patterns and conventions in each file.
Do not invent new patterns.
After each file confirm what was written.

STEP 5 — Tests
Write unit tests and UI tests for every new spec item.
Follow the project's testing conventions and existing structure.
Use existing fixtures where possible.

STEP 6 — Spec and registry cleanup
Confirm all new spec items have matching tests.
Record any known gaps and the session summary via update_project.

STEP 7 — Commit
One commit per repo touched.
Commit message format:
[AREA-IDs]: brief description

Full explanation of what changed and why.
Spec: [spec file and item IDs]
Tests: [test class and method names]

Show me all commit messages before committing.
Wait for my approval.
