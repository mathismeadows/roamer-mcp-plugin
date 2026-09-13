---
name: status
description: List which Roamer MCP identities are cached, and which is active, for every client on this machine (or one specific client)
allowed-tools: ["Bash", "ReadMcpResourceTool", "mcp__roamer__read_resource_by_uri", "mcp__roamer__whoami"]
---

Call `read_resource_by_uri` with uri `roamer://prompt/status.md` to fetch this workflow's current instructions, then follow them exactly from their own first step. The fetched text is the authoritative source for this skill — do not skip, summarize, or substitute steps from memory of a prior version.
