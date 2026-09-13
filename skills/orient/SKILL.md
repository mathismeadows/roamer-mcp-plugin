---
name: orient
description: Start-of-session briefing — read the project registry and open engineering threads, then recommend the top 3 most valuable next steps. Optionally scope to one product or project.
argument-hint: "[optional: product or project name]"
allowed-tools: ["mcp__roamer__read_resource_by_uri", "mcp__roamer__get_registry", "mcp__roamer__get_threads", "mcp__roamer__get_project"]
---

If a product or project name was given as an argument, call `read_resource_by_uri` with uri `roamer://prompt/orient/<that name>.md` (URL-encode the name if it contains spaces or special characters). Otherwise call `read_resource_by_uri` with uri `roamer://prompt/orient.md`.

Then follow the fetched text exactly from its own first step. The fetched text is the authoritative source for this skill — do not skip, summarize, or substitute steps from memory of a prior version.
