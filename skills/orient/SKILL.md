---
name: orient
description: Start-of-session briefing — read the project registry and open engineering threads, then recommend the top 3 most valuable next steps. Optionally scope to one product or project.
argument-hint: "[optional: product or project name]"
allowed-tools: ["mcp__plugin_roamer_mcp__read_resource_by_uri", "mcp__plugin_roamer_mcp__get_registry", "mcp__plugin_roamer_mcp__get_threads", "mcp__plugin_roamer_mcp__get_project"]
---

If text follows the `orient` command, that text is the scope: call `read_resource_by_uri` with `roamer://prompt/orient/<the text, URL-encoded>.md` — for example `roamer://prompt/orient/Acme%20Widgets.md` — and the server fills the scope into the workflow. If nothing follows the command, call `read_resource_by_uri` with `roamer://prompt/orient.md`. If you can't tell whether text was supplied, ask for the scope rather than running an unscoped briefing.

Then follow the fetched text exactly from its own first step. The fetched text is the authoritative source for this skill — do not skip, summarize, or substitute steps from memory of a prior version.
