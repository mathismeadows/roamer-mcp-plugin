---
name: login
description: Switch which Roamer MCP identity this client is signed in as — runs a fresh interactive sign-in without disturbing any other cached identity
allowed-tools: ["Bash", "AskUserQuestion", "ReadMcpResourceTool", "mcp__roamer__read_resource_by_uri", "mcp__roamer__whoami"]
---

Call `read_resource_by_uri` with uri `roamer://prompt/login.md` to fetch this workflow's current instructions, then follow them exactly from their own first step. The fetched text is the authoritative source for this skill — do not skip, summarize, or substitute steps from memory of a prior version.
