---
name: logout
description: Clear a Roamer MCP client's active cached identity (or every identity cached for it), so its next connection signs in fresh
allowed-tools: ["Bash", "AskUserQuestion", "ReadMcpResourceTool", "mcp__roamer__whoami"]
---

If this session is on the claude.ai-brokered HTTP connector instead of the local stdio bridge: there's no separate logout action to run here. Disconnecting and reconnecting the connector itself (via your client's Connector or MCP server settings panel) forces a fresh sign-in, and may show a chooser if more than one account is currently signed in in your browser. Call the `whoami` tool (a normal tool call, distinct from the `roamer://whoami` resource mentioned below) before disconnecting to see which identity is currently active, and again after reconnecting to confirm the switch actually took.

Run `npx -y @mathismeadows/roamer-device-auth status` via Bash (no arguments) to see every client slug that has a cached identity on this machine.

Resolve which client slug the user means: first try reading the resource `roamer://whoami` (ReadMcpResourceTool) from whichever Roamer MCP server connection this session already has — typically the installed plugin's own connection. If it returns a real clientSlug, that's ground truth for this exact session — use it directly, no guessing needed.

If that read fails ("resource not found" — this session's own bridge process hasn't been restarted onto a version that supports it yet, or this session isn't on the local stdio bridge at all, e.g. the claude.ai-brokered connector, which has no client-slug concept), fall back to the manual procedure below, the same way `login` does: **always confirm with the user before acting — never proceed on a resolved slug without them explicitly agreeing it's the one they mean, even if `status` lists only one.** A client that hasn't reconnected recently can be completely invisible to `status`'s listing, so "exactly one slug shown" does not mean no other real session exists — this exact gap once caused a real mistake: logging out a completely different, unrelated session that simply wasn't visible in the list. Show the user the full `status` output and ask which app they're talking to you from right now, rather than guessing — and do not infer it from environment variables or file timestamps, since a more recently active concurrent session on the same machine would make that guess wrong. If `status` shows nothing cached for any slug, tell the user there's nothing to log out of and stop.

Ask whether they want to clear just the active identity for that slug, or every identity ever cached for it — default to just the active one unless they specifically ask to clear all of them.

Run `npx -y @mathismeadows/roamer-device-auth logout --client <slug>` via Bash (add `--all` only if they asked for that).

Report the result plainly. Remind them the client's next connection will sign in fresh automatically — no separate `login` call is required afterward unless they specifically want to choose which identity to sign in as ahead of time, in which case point them at `/roamer:login`.
