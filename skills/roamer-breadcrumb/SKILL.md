---
name: roamer-breadcrumb
description: End-of-session checkpoint — update MCP project registry with git status and session summary
allowed-tools: ["mcp__roamer__update_project", "mcp__roamer__get_registry", "mcp__roamer__log_thread"]
disable-model-invocation: true
---

Before writing anything, check git status and recent git log across all repos in this workspace to identify which projects were touched this session.

For EACH project that was touched, call update_project with:
- name: the project name
- currentBranch: current git branch for that repo
- branchPurpose: what this branch is working toward
- lastSessionSummary: for this specific project —
    * what was attempted
    * what was verified working
    * what was attempted and failed, and why
    * what decisions were made and the rationale
    * what assumptions are now baked into the code
    * what is explicitly known broken or incomplete
- nextStep: what the next session should do first in this project, and what it must know before touching anything

After all updates are written, call get_registry and confirm each touched project shows the new summary.

Then, for any engineering threads opened, updated, or closed this session, call log_thread to record the update.
