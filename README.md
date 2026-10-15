# roamer-mcp-plugin

[![Listed on mcpservers.org](https://mcpservers.org/badge.svg)](https://mcpservers.org/servers/mathismeadows/roamer-mcp-plugin)

Distributable Claude Code plugin for RoamerMcp — the Roamer project registry, behavioral spec database, and engineering threads MCP server. Learn more at [roamermcp.mathismeadows.com](https://roamermcp.mathismeadows.com).

The plugin is an optional extra on top of the hosted Roamer MCP server (`https://roamer-mcp.mathismeadows.com/mcp`). Connecting to that server on its own already gives every tool and workflow; installing this plugin adds eleven workflows as slash commands. Each is a slash command, but Claude can also invoke one on its own when the conversation calls for it — you don't have to type the command yourself:

- `/roamer:orient` — start-of-session briefing (project registry + open threads)
- `/roamer:breadcrumb` — end-of-session checkpoint (registry + thread updates)
- `/roamer:feature` — seven-step gated feature workflow
- `/roamer:bug` — eight-step gated bug-fix workflow
- `/roamer:spec-audit` — spec coverage audit
- `/roamer:spec-check` — hygiene checklist
- `/roamer:thread-scrub` — guided review and disposition of the open-thread backlog, on demand
- `/roamer:release-notes` — draft Internal/External release notes for a date window, review-only
- `/roamer:login` — sign in, or switch which identity this session uses
- `/roamer:logout` — sign this session's Roamer connection out
- `/roamer:status` — see which identity this connection is signed in as

## Install

```
/plugin marketplace add mathismeadows/roamer-mcp-plugin
/plugin install roamer@roamer
```

The plugin connects to the hosted server over HTTP — no Node.js or local install. On first use, sign in with `/mcp`: select the plugin's Roamer server and follow the browser sign-in. To switch accounts later, use `/mcp` → **Re-authenticate**, or **Clear authentication** to sign out.

Keep one Roamer connection per client. If you've also added Roamer as a claude.ai connector or with `claude mcp add`, Claude Code treats a plugin server and a connector on the same URL as duplicates and ranks the plugin's first. Turn off any other Roamer server in `/mcp` so it's clear which one a session is using.

### Upgrading from 1.x

Version 2.0 changes how the plugin connects. 1.x started a local bridge (`npx @mathismeadows/roamer-device-auth`) under the server name `roamer`; 2.0 connects straight to the hosted server under the server name `mcp`, so its tools are named `mcp__plugin_roamer_mcp__<tool>`. After updating:

- Sign in once more with `/mcp` (the bridge's cached sign-in isn't used by 2.0).
- If a server named `roamer` is still listed — in `/mcp`, or in VS Code's MCP Servers view — remove it and reload. A leftover `roamer` server can show an error with no output.
- Tool approvals you gave the old `roamer` server don't carry over to the new name.

## Status

This repo is public — install directly with the commands above. New accounts are provisioned automatically on first login, but currently need manual approval before they can use RoamerMcp's tools (a beta access gate); you'll be notified once yours is enabled.

## Structure

- `.claude-plugin/plugin.json` — plugin manifest
- `.claude-plugin/marketplace.json` — self-referential marketplace entry
- `.mcp.json` — the hosted Roamer MCP server over HTTP, under the server name `mcp`
- `skills/` — the workflow commands above; each one reads its current instructions from the server

This repo is distribution-only — it has no server code, no tests, and no relation to RoamerMcp's internal architecture beyond consuming its public MCP endpoint.
