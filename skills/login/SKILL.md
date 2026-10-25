---
name: login
description: Sign in, or switch which Roamer MCP identity this session uses — on a claude.ai connector, a direct HTTP connection, or the local stdio bridge
allowed-tools: ["Bash(npx -y @mathismeadows/roamer-device-auth:*)", "AskUserQuestion", "ReadMcpResourceTool", "mcp__plugin_roamer_mcp__read_resource_by_uri", "mcp__plugin_roamer_mcp__whoami"]
---

Call `read_resource_by_uri` with uri `roamer://prompt/login.md` to fetch this workflow's current instructions, then follow them exactly from their own first step. The fetched text is the authoritative source for this skill — do not skip, summarize, or substitute steps from memory of a prior version.
