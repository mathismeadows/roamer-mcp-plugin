# roamer-mcp-plugin

Distributable Claude Code plugin for [RoamerMcp](https://github.com/h6rbgk2xhr/roamer-mcp) — the Roamer project registry, behavioral spec database, and engineering threads MCP server.

Installing this plugin gives you six workflows backed by the same tools RoamerMcp exposes over MCP. Each is a slash command, but Claude can also invoke one on its own when the conversation calls for it — you don't have to type the command yourself:

- `/roamer:orient` — start-of-session briefing (project registry + open threads)
- `/roamer:breadcrumb` — end-of-session checkpoint (registry + thread updates)
- `/roamer:feature` — seven-step gated feature workflow
- `/roamer:bug` — eight-step gated bug-fix workflow
- `/roamer:spec-audit` — spec coverage audit
- `/roamer:spec-check` — hygiene checklist

## Install

```
/plugin marketplace add mathismeadows/roamer-mcp-plugin
/plugin install roamer
```

On first use, Claude Code will prompt you to authenticate against the hosted RoamerMcp endpoint (per-user Entra ID login via OAuth) — no manual token setup required.

## Status

This repo is public — install directly with the commands above. New accounts are provisioned automatically on first login, but currently need manual approval before they can use RoamerMcp's tools (a beta access gate); you'll be notified once yours is enabled.

## Structure

- `.claude-plugin/plugin.json` — plugin manifest
- `.claude-plugin/marketplace.json` — self-referential marketplace entry
- `.mcp.json` — spawns `scripts/roamer-bridge.sh` via `${CLAUDE_PLUGIN_ROOT}`
- `scripts/` — the same local stdio bridge (authenticates against RoamerMcp's own OAuth server — a device-code flow for Safari-default machines, a lighter loopback redirect for everything else — via the published `@mathismeadows/roamer-device-auth` npm package, invoked via `npx`) used by RoamerMcp's own dev setup
- `skills/` — the six workflow commands above

This repo is distribution-only — it has no server code, no tests, and no relation to RoamerMcp's internal architecture beyond consuming its public MCP endpoint.
