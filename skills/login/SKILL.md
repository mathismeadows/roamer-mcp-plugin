---
name: login
description: Switch which Roamer MCP identity this client is signed in as — runs a fresh interactive sign-in without disturbing any other cached identity
allowed-tools: ["Bash", "AskUserQuestion", "ReadMcpResourceTool"]
---

Run `npx -y @mathismeadows/roamer-device-auth status` via Bash (no arguments) to see every client slug that already has a cached identity on this machine.

Resolving which client slug this session is: first try reading the resource `roamer://whoami` (ReadMcpResourceTool) from whichever Roamer MCP server connection this session already has — typically the installed plugin's own connection. If it returns a real clientSlug, that's ground truth for this exact session — use it directly, no guessing or confirmation question needed.

If that read fails ("resource not found" — this session's own bridge process hasn't been restarted onto a version that supports it yet, since an already-spawned process never hot-swaps — or this session isn't on the local stdio bridge at all, e.g. the claude.ai-brokered connector, which has no client-slug concept), fall back to the manual procedure below. **Always confirm with the user before acting on a manually-resolved slug — never proceed without them explicitly agreeing it's the one they mean, even if `status` lists only one.** Found live: a client slug that hasn't reconnected since a bridge upgrade only has an old-format cache file and can be completely invisible to `status`'s listing — "exactly one slug shown" does NOT mean "no other real session exists," it can just mean every other real session hasn't shown up in the listing yet. Acting on a lone visible slug without confirmation once caused a real cross-session mistake (logging out a completely different, unrelated session that simply wasn't visible in the list).
- Show the user the full `status` output, then ask which app they're talking to you from right now (Claude Code CLI, Cursor, VS Code, Claude Desktop, etc.) and get an explicit answer identifying the slug — even when only one is listed.
- Do not infer the slug from environment variables or file timestamps — neither reliably identifies which of several concurrently-running sessions is this one; a file's recency can point at a completely different, more recently active session on the same machine.
- If none of the listed slugs obviously match what the user describes, ask them to just say the slug shown in the status output that they believe is theirs.
- If `status` reports nothing cached anywhere yet, this is a genuinely first-ever sign-in — ask what to call this client (e.g. "claude-code") to get the value the underlying `login` command requires as `--client <slug>`.

Once you have the client slug, run `npx -y @mathismeadows/roamer-device-auth login --client <slug>` via Bash. This performs a real interactive sign-in — tell the user before running it to expect a browser tab/window to open (or, on Safari-default Macs, a native macOS dialog with a short code and URL), and that they need to actually complete the sign-in there themselves; you cannot do that step on their behalf. Wait for the command to finish rather than treating it as fire-and-forget.

Report the command's own output back to the user plainly once it finishes (it states who ended up signed in, e.g. "Signed in as person@example.com — now the active identity for claude-code"). If it errors, show the actual error text rather than a generic "it failed."

Finally, remind the user: an already-running session for that same client will not pick up the new identity until it's actually restarted — reconnecting alone is not enough (an already-spawned bridge process never hot-swaps).
