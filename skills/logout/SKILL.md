---
name: logout
description: Clear a Roamer MCP client's active cached identity (or every identity cached for it), so its next connection signs in fresh
allowed-tools: ["Bash", "AskUserQuestion", "ReadMcpResourceTool", "mcp__roamer__read_resource_by_uri", "mcp__roamer__whoami"]
---

Call `read_resource_by_uri` with uri `roamer://prompt/logout.md` to fetch this workflow's current instructions, then follow them exactly from their own first step. The fetched text is the authoritative source for this skill — do not skip, summarize, or substitute steps from memory of a prior version.
