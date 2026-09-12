---
name: thread-scrub
description: Guided review and disposition of the open-thread backlog — walks threads in priority/staleness order and helps decide what to do with each one. On-demand only, never run automatically as part of another workflow.
argument-hint: "[optional: product or project name]"
allowed-tools: ["mcp__roamer__get_threads", "mcp__roamer__get_thread", "mcp__roamer__log_thread"]
---

If a product or project name was mentioned, resolve it first: read resource roamer://brain/overview.md to identify all projects belonging to the named product — if it matches a known product, use its full constituent project list; otherwise treat the name as a single project.

If no scope was mentioned, this scrub covers open threads across the full ecosystem.

Call get_threads with scrubOrder:true (pass projectNames as the resolved list above, if scoped).

For each thread in the order returned, if its Synopsis is missing, or reads as stale next to the most recent dated update in its body, call get_thread for the full narrative and form your own current-state judgment before presenting it — don't rely on a synopsis you don't trust.

Present threads one at a time, in the order returned. For each, give a one-line "here's my read" summary, then offer a disposition:
1. **Keep open as-is**
2. **Keep open, but update Synopsis and/or Priority** (call log_thread with just the new value(s), every other field omitted)
3. **Escalate** — this deserves a real spec item or blocker, not just a thread (self-trigger the feature/bug workflow or call log_blocker, then update this thread noting the escalation)
4. **Merge into another thread** (call log_thread on the surviving thread appending the merged content, then close this one as reference-only)
5. **Close as resolved** — the underlying work is actually done
6. **Close as reference-only** — no further action needed, but the history is worth keeping searchable

Wait for the user's choice on each thread before acting — do not batch decisions or apply a default. Before any call that closes a thread (log_thread with isOpen:false), state explicitly which of resolved / reference-only / escalated this is, so the closure reason is recorded, not just the fact of closing.

No bulk actions of any kind — every disposition on every thread is its own explicit, individually confirmed call.

When the pass is complete, summarize how many threads were kept, updated, escalated, merged, or closed, and in which lane.
