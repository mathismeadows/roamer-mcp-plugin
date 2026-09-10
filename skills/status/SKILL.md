---
name: status
description: List which Roamer MCP identities are cached, and which is active, for every client on this machine (or one specific client)
allowed-tools: ["Bash", "ReadMcpResourceTool", "mcp__roamer__whoami"]
---

If this session is on the claude.ai-brokered HTTP connector instead of the local stdio bridge: there's no cached-identity list to show here. Call the `whoami` tool directly (a normal tool call, distinct from the `roamer://whoami` resource mentioned below) — it reports which identity this exact connection is currently authorized as, resolved fresh from the request, which is the closest equivalent this transport has to a status check.

Run `npx -y @mathismeadows/roamer-device-auth status` via Bash (no arguments) to list every client slug that has any cached identity, and which identity is active for each.

Present the result to the user plainly — relay what's actually cached, don't editorialize about which one is "correct" or should be active.

If this session is itself connected via Roamer MCP's local stdio bridge, also try reading the resource `roamer://whoami` (ReadMcpResourceTool) from that connection and call out which listed slug corresponds to this exact session — ground truth, not a guess. If that read fails (bridge process not yet restarted onto a version that supports it, or this session isn't on the local bridge at all), just skip it silently; the plain cached-identity listing above still stands on its own.

If the user wants detail on one specific client (e.g. "what's cached for Cursor"), re-run with `--client <slug>` using the slug shown in the first listing, to see every identity cached for that one client (not just its active one).
