---
name: status
description: Show which identity this Roamer MCP connection is signed in as — and, on the local stdio bridge, every identity cached on this machine
allowed-tools: ["ReadMcpResourceTool", "mcp__plugin_roamer_mcp__read_resource_by_uri", "mcp__plugin_roamer_mcp__whoami"]
---

Call `read_resource_by_uri` with uri `roamer://prompt/status.md` to fetch this workflow's current instructions, then follow them exactly from their own first step. The fetched text is the authoritative source for this skill — do not skip, summarize, or substitute steps from memory of a prior version.
