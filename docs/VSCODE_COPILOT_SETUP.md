# Roamer MCP in VS Code (GitHub Copilot Chat)

This documents the **sanctioned, native VS Code mechanism** for this plugin — not a manual workaround. Source: VS Code's own docs (`Agent Skills`, `Agent Plugins`, `MCP servers`, `Agent Host`), fetched and verified 2026-09-11. If any of this stops matching reality, treat the docs as ground truth over anything previously hacked into local config.

## The two independent mechanisms

VS Code has a native **Agent Plugins** feature (`chat.plugins.enabled`), completely separate from Claude Code's own plugin system. It auto-detects a plugin's manifest format — this repo uses `.claude-plugin/plugin.json`, so VS Code treats it as "Claude format" — and exposes two portable component types from it:

1. **Skills** — discovered from the plugin's `skills/*/SKILL.md` folder. These are the `/roamer:orient`, `/roamer:bug`, etc. commands.
2. **MCP servers** — discovered from the plugin's root `mcp.json`/`.mcp.json`. This is the `roamer` stdio bridge (`scripts/roamer-bridge.sh`).

Per VS Code's docs: **"Plugin MCP servers start automatically when the plugin is enabled... appear alongside workspace and user-level MCP servers... implicitly trusted when you install the plugin."**

**This means a manually-added `"Roamer MCP"` entry in `mcp.json` (workspace or user profile) should never be necessary for this plugin, once actually installed as an Agent Plugin.**

## Verified ground truth (2026-09-11)

Checked directly in this environment via the real UI surfaces, not by inference:

- `MCP: List Servers` showed exactly **one** `Roamer MCP` entry — the manually-configured stdio server in `mcp.json`. No plugin-native server, no duplicate.
- Extensions view → Agent Plugins search `@agentPlugins Roamer` → **"No agent plugins found."**

Conclusion: `roamer` was never actually installed through VS Code's real Agent Plugins mechanism here. A folder at `~/.vscode/agent-plugins/github.com/mathismeadows/roamer-mcp-plugin/` exists on disk and happens to contain the plugin's `skills/*/SKILL.md` files, but it is **not** the real Agent Plugins install location and is not what the Extensions view's Agent Plugins search reads. Whatever is causing `/roamer:*` skill content to auto-attach in chat is a separate mechanism from the documented, product-level Agent Plugins feature — not yet identified. The manual `mcp.json` entry has been the *only* thing providing working Roamer MCP tool calls the whole time; there was never a real duplicate-server risk to worry about.

**The real fix is to actually install the plugin the sanctioned way**, which per the docs should provide both auto-managed skills and an auto-started MCP server, making the manual `mcp.json` entry unnecessary:

1. Command Palette → `Chat: Install Plugin From Source` → enter `mathismeadows/roamer-mcp-plugin`, **or** Extensions view → `@agentPlugins` → add the marketplace (`chat.plugins.marketplaces`) and install from there.
2. Confirm it now appears under Agent Plugins - Installed and is enabled.
3. Re-check `MCP: List Servers` — a plugin-native `roamer` server should now appear on its own.
4. Only once that's confirmed working, remove the manual `mcp.json` entry.

## Resolved (2026-09-11)

Ran `Chat: Install Plugin From Source` with `mathismeadows/roamer-mcp-plugin`. It now appears correctly under Extensions → Agent Plugins - Installed (enabled, with Disable/Uninstall/Open Plugin Folder/Open README actions). The manual `"Roamer MCP"` entry was removed from the user `mcp.json`, and a fresh `whoami` call succeeded — confirming a plugin-managed connection was serving tool calls, not the installation mechanism itself being broken. The earlier "No agent plugins found" state was simply because the plugin had never actually been installed through this mechanism yet.

**Correction, same day:** the above did not mean the bundled `.mcp.json` was actually working. `.mcp.json`'s `command` field was `"${CLAUDE_PLUGIN_ROOT}/scripts/roamer-bridge.sh"` — `${CLAUDE_PLUGIN_ROOT}` is a **Claude Code-only** env var; VS Code's Agent Plugins host never populates it, so VS Code tried to exec the literal, unexpanded string and failed outright (no process, no server). This went unnoticed here because a manually-added `mcp.json` entry was still providing the working connection at the time `whoami` was tested, masking the bundled server's failure. Verified directly: before the fix, `ps aux` showed no `roamer-device-auth` process at all despite the plugin showing "enabled"; after the fix, VS Code prompted to restart the server and the process launched successfully.

Fixed in `1.3.4`: `.mcp.json` now runs `"npx"` with `args: ["-y", "@mathismeadows/roamer-device-auth"]` directly — no env var dependency, works identically on both hosts. This is the actual fix that makes the "no manual `mcp.json` entry needed" claim below true. Do not reintroduce a manual entry as a workaround if the bundled server ever appears not to start — check `.mcp.json`'s literal `command` field first.



## How Skills actually run (no visible "sausage-making")

Per VS Code's docs: *"Discovery: Copilot reads the skill's name/description... Instructions loading: Copilot loads the SKILL.md body into its context. You can also trigger this directly by typing `/skill-name` in chat."*

This means typing `/roamer:status` (or similar) causes VS Code itself to auto-attach the matching `SKILL.md` content to the conversation — the agent should just follow those instructions directly. There is no legitimate reason for the agent to separately `read_file`/`grep`/`list_dir` the plugin's installed skill folder on disk; if the content is already attached, re-fetching it is redundant noise, not a required step.

## Correct setup, top-down

1. Confirm `chat.plugins.enabled` is `true` (default).
2. Install the plugin via the Agent Plugins mechanism, not by hand-editing `mcp.json`:
   - Extensions view (`Cmd+Shift+X`) → search `@agentPlugins` → find/install `roamer`, **or**
   - Command Palette → `Chat: Install Plugin From Source` → `mathismeadows/roamer-mcp-plugin`.
3. Command Palette → `Extensions: Agent Plugins - Installed` (or the Extensions view's Agent Plugins section) → confirm `roamer` is **enabled**, not just installed.
4. Command Palette → `MCP: List Servers` → confirm a `roamer` server is present and started **without any manual `mcp.json` entry**.
5. First real tool call triggers the bridge's own interactive sign-in (device-code or loopback OAuth, same mechanism Claude Code uses) — authentication is per-client-slug and cached independently of Claude's own cache.

## Known, expected duplication — not a bug

RoamerMcp's own server independently exposes the same six workflows as native **MCP prompts** (`/<server>.<prompt>` syntax — a distinct MCP capability from plugin Skills). Seeing both a `/roamer:orient` Skill and an MCP-prompt equivalent is expected and already tracked upstream (Roamer MCP thread `VSCODE-agent-plugins-duplicate-prompts`) — not something to "fix" from this repo.

## Teardown / reinstall (to verify from a clean state)

1. Extensions view → Agent Plugins - Installed → right-click `roamer` → **Uninstall**.
2. Remove any manually-added `"Roamer MCP"`/`"roamer"` entry from `.vscode/mcp.json` or the user-profile `mcp.json` if one exists — it should not be needed.
3. Reinstall per "Correct setup" above.
4. Verify via `MCP: List Servers`, not by re-adding a manual config entry.

## Background reading

- https://code.visualstudio.com/docs/agent-customization/agent-plugins
- https://code.visualstudio.com/docs/agent-customization/agent-skills
- https://code.visualstudio.com/docs/agent-customization/mcp-servers
- https://code.visualstudio.com/docs/agents/concepts/agent-host
