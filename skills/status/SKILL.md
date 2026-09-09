---
name: status
description: List which Roamer MCP identities are cached, and which is active, for every client on this machine (or one specific client)
allowed-tools: ["Bash"]
---

Run `npx -y @mathismeadows/roamer-device-auth status` via Bash (no arguments) to list every client slug that has any cached identity, and which identity is active for each.

Present the result to the user plainly — relay what's actually cached, don't editorialize about which one is "correct" or should be active.

If the user wants detail on one specific client (e.g. "what's cached for Cursor"), re-run with `--client <slug>` using the slug shown in the first listing, to see every identity cached for that one client (not just its active one).
