---
name: logout
description: Clear a Roamer MCP client's active cached identity (or every identity cached for it), so its next connection signs in fresh
allowed-tools: ["Bash", "AskUserQuestion"]
---

Run `npx -y @mathismeadows/roamer-device-auth status` via Bash (no arguments) to see every client slug that has a cached identity on this machine.

Resolve which client slug the user means the same way `login` does: if there is exactly one, use it; if there's more than one, ask the user which app they're talking to you from right now rather than guessing — do not infer it from environment variables or file timestamps, since a more recently active concurrent session on the same machine would make that guess wrong. If `status` shows nothing cached for any slug, tell the user there's nothing to log out of and stop.

Ask whether they want to clear just the active identity for that slug, or every identity ever cached for it — default to just the active one unless they specifically ask to clear all of them.

Run `npx -y @mathismeadows/roamer-device-auth logout --client <slug>` via Bash (add `--all` only if they asked for that).

Report the result plainly. Remind them the client's next connection will sign in fresh automatically — no separate `login` call is required afterward unless they specifically want to choose which identity to sign in as ahead of time, in which case point them at `/roamer:login`.
