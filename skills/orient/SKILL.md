---
name: orient
description: Start-of-session briefing — read the project registry and open engineering threads, then recommend the most valuable next step. Optionally scope to one product or project (e.g. 'Peeps').
argument-hint: "[optional: product or project name]"
allowed-tools: ["mcp__roamer__get_registry", "mcp__roamer__get_threads", "mcp__roamer__get_project"]
disable-model-invocation: true
---

If a product or project name was mentioned (e.g. "Peeps", "RoamerMcp"), use **scoped mode**. Otherwise use **ecosystem mode**.

---

**Scoped mode** (a product or project name was mentioned):

Read resource roamer://brain/overview.md to identify all projects belonging to the named product.
If no product match is found, treat the name as a single project.
Call get_project for each matched project.
Call get_threads (open only) and note any threads whose relatedProjects overlaps the scope.

Give me a focused briefing for each project in scope:
- What was verified working last session
- What was attempted and failed, and why
- What decisions are baked in that I need to know
- What is known broken or incomplete
- What the next step is
- Any unresolved blockers

Then end with cross-project blockers within the scope, relevant open threads, and a single next-step recommendation.

Do not start any work. Wait for me to confirm or redirect.

---

**Ecosystem mode** (no scope specified):

Call get_registry and get_threads (open threads only).

Give me a full briefing across ALL Roamer projects:

For each project:
- What was verified working last session
- What was attempted and failed, and why
- What decisions are baked in that I need to know
- What is known broken or incomplete
- What the next step is
- Any unresolved blockers

Then end with:
- A list of active cross-project blockers
- A summary of open engineering threads
- A single recommendation: what is the most valuable thing to work on this session across all projects

Do not start any work. Wait for me to confirm or redirect.
