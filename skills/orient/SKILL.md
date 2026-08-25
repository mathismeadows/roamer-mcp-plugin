---
name: orient
description: Start-of-session briefing — read the project registry and open engineering threads, then recommend the top 3 most valuable next steps. Optionally scope to one product or project.
argument-hint: "[optional: product or project name]"
allowed-tools: ["mcp__roamer__get_registry", "mcp__roamer__get_threads", "mcp__roamer__get_project"]
---

If a product or project name was mentioned, use **scoped mode**. Otherwise use **workspace mode**.

---

**Value equation** (apply this whenever a next-step recommendation is produced, in either mode):

Rank candidate next steps — breadcrumb next-steps, open thread items, and spec items pulled from the backlog — against these criteria, roughly in this order:

1. **Breadcrumb immediacy** — a breadcrumb is pre-loaded context and momentum. It starts ahead unless a factor below overrides it.
2. **Customer-facing impact** — anything a user directly experiences outranks internal-only work at the same priority tier.
3. **Spec priority (P0 > P1 > P2)**.
4. **Unblocking power** — work that unlocks other work is multiplicative; a small unblocker can outweigh a large isolated task.
5. **Decay risk** — items whose cost increases over time (security gaps, shifting dependencies, compounding debt) get bumped even outside strict priority order.
6. **Estimated effort** — favor items closable in under ~5 machine-hours. Larger P0/P1 items aren't skipped — they're broken into a sub-5-hour first slice instead of recommended whole.
7. **Estimate confidence** — a smaller, well-understood item beats a vaguely-scoped one of similar nominal value. Low-confidence estimates are flagged, not blindly picked.
8. **Risk isolation** — prefer surfacing or retiring a risky unknown early over building more work on top of it.
9. **Arc completion** — finishing the last piece of an arc (spec area, thread, milestone) is worth a premium over a same-effort item that leaves everything else open-ended.
10. **Momentum / context-switch cost** — if two candidates are close, prefer continuing the branch/thread already in play this session over starting cold elsewhere.

**Output: top three, diversified.** Don't collapse this to one winner. Using the ranking above, select:

1. **Top overall item** — the strongest candidate by the full criteria order.
2. **Strongest unblocker** — regardless of overall rank, the item that most exemplifies criterion 4 (unlocks the most other work).
3. **Closest to finishing an arc** — regardless of overall rank, the item that most exemplifies criterion 9 (completes a spec area, thread, or milestone).

If an item would fill more than one slot, keep it in the slot it's strongest for and move to the next-best candidate for the other slot(s), so the three stay distinct. This is a qualitative pass over the same ranking, not a separate scoring system — there's no numeric "unblocking score" or "arc score" to compute, just "which candidate best exemplifies this criterion."

For each of the three, name it and give the one or two criteria that decided it over the runner-up, so the reasoning is inspectable, not asserted.

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

Then end with cross-project blockers within the scope, relevant open threads, and the top-three next-step recommendation, decided using the value equation above.

Do not start any work. Wait for me to confirm or redirect.

---

**Workspace mode** (no scope specified):

Call get_registry and get_threads (open threads only).

Give me a full briefing across all registered projects:

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
- The top-three next-step recommendation: the most valuable things to work on this session across all projects, decided using the value equation above

Do not start any work. Wait for me to confirm or redirect.
