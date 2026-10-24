---
name: export
description: Save a snapshot of Roamer content to local files in a format you choose — optionally scoped to one product or project, and to specs, threads or the brain. Read-only.
argument-hint: "[optional: product or project name] [optional: spec, thread, brain or all]"
allowed-tools: ["mcp__plugin_roamer_mcp__read_resource_by_uri", "mcp__plugin_roamer_mcp__get_brain", "mcp__plugin_roamer_mcp__get_registry", "mcp__plugin_roamer_mcp__get_project", "mcp__plugin_roamer_mcp__list_specs", "mcp__plugin_roamer_mcp__get_spec_area", "mcp__plugin_roamer_mcp__get_spec_item", "mcp__plugin_roamer_mcp__get_threads", "mcp__plugin_roamer_mcp__get_thread", "mcp__plugin_roamer_mcp__get_blocker"]
---

Text after the `export` command can give a scope (a product or project name), the data to save (`spec`, `thread`, `brain` or `all`, or a comma-separated list such as `spec,thread`), or both. Call `read_resource_by_uri` with `roamer://prompt/export.md`, adding whichever were given as URL-encoded query parameters, scope first — for example `roamer://prompt/export.md?scope=Acme%20Widgets&data=spec%2Cthread`, or `roamer://prompt/export.md?data=brain` for the data alone. With nothing after the command, read `roamer://prompt/export.md` as it is. If you can't tell which part is the scope and which the data, ask rather than guessing.

Then follow the fetched text exactly from its own first step. The fetched text is the authoritative source for this skill — do not skip, summarize, or substitute steps from memory of a prior version.
