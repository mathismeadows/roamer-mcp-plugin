---
name: breadcrumb
description: End-of-session checkpoint — detect merged branches (REG-07), update spec-item status (SPC-06), and write full session narrative only for still-active work
allowed-tools: ["mcp__roamer__update_project", "mcp__roamer__log_spec_item", "mcp__roamer__get_project", "mcp__roamer__log_thread"]
disable-model-invocation: true
---

Before writing anything, check git status and recent git log across all repos in this workspace to identify which projects were touched this session, and for each touched branch, check whether it has since merged to main/develop (or been deleted with no open PR).

For any branch that has merged or been deleted: call update_project with name, currentBranch, and branchMerged=true instead of a session summary. This removes that branch's session history outright (REG-07) — no narrative summary, no tombstone. Its contribution now lives in main/develop and in the status of the spec items it touched, not in a retained log.

For any spec items you completed, advanced, or newly drafted this session: call log_spec_item with an updated status field (SPC-06) — spec-item status is now the primary record of "what happened" going forward, not session narrative.

For any spec item you just advanced to a code-complete-* status: if it changed something this project's own documentation claims about itself (a count, a capability list, a described behavior — e.g. RoamerMcp's ARCHITECTURE.md/brain self-referential counts, or any other product's README/architecture doc making a similar claim), check that document against reality before finishing, and flag any mismatch you find rather than letting it persist silently (ARC-05). This doesn't mean syncing every doc to match every other doc — only that each document's own claims about itself stay honest.

For each project with a branch that is STILL active/unfinished (not merged this session), call update_project with:
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

After all updates are written, call get_project for each touched project and confirm its Arc Position (REG-08) reflects this session's spec-item status changes, and that any merged branches no longer appear.

Then, for any engineering threads opened, updated, or closed this session, call log_thread to record the update.
