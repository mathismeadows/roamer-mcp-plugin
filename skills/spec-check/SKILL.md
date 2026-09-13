---
name: spec-check
description: End-of-session hygiene check — verify unit tests, TODOs, and docs stay in sync with this session's changes
allowed-tools: ["Read", "Glob", "Grep", "Bash", "mcp__roamer__read_resource_by_uri"]
---

Call `read_resource_by_uri` with uri `roamer://prompt/spec-check.md` to fetch this workflow's current instructions, then follow them exactly from their own first step. The fetched text is the authoritative source for this skill — do not skip, summarize, or substitute steps from memory of a prior version.
