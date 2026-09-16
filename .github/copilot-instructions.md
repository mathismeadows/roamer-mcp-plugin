# RoamerMcpPlugin Copilot Instructions

## Roamer MCP Guardrail

- This repository is part of the Roamer MCP ecosystem. Use Roamer MCP for registry, spec, thread, and blocker state before making ecosystem changes.
- If Roamer MCP is unavailable or unauthenticated, stop and request re-authorization unless the user explicitly authorizes a specific bounded task without it.
- When a bug or feature is described in conversation, follow the repository's gated Roamer bug/feature workflow rather than making ad-hoc changes.

## Shell and Repository Scope

- Prefer minimal shell commands without banners or chained `&&` sequences.
- Use explicit repository paths or `--repo` arguments for Git and GitHub commands.
- Before committing, inspect the changed-file list and keep unrelated working-tree changes untouched.
- Do not push, publish, or release until focused validation is complete.

## Command Execution

- Execute simple checks directly; do not generate scripts or heredocs for one-off commands.
- Do not wrap simple commands in Python, `awk`, `grep`, or similar output-processing scripts just to summarize them.
- When a command already wrote a result file, read that file directly instead of rerunning it or creating a parser.
- Run plain `gh` commands directly; do not add unnecessary pager or terminal environment-variable plumbing.
- Do not treat a timeout as a failure; inspect the existing operation before concluding.
- Use workspace tools for file searches and edits when they provide the needed capability.

## Repository Scope

- This is a distribution-only Claude Code plugin. Keep changes limited to plugin manifests, marketplace metadata, skills, scripts, and documentation.
- Do not add RoamerMcp server implementation or duplicate server-side business logic here.
- Preserve the plugin's marketplace/package structure and test authentication/distribution changes against the hosted RoamerMcp endpoint when validation is available.

## Secrets and Live Access

- Never print tokens, client secrets, or other credentials.
- Live MCP checks must remain read-only and must use the shared authenticated fixture or supported device-auth flow.
- A green local structural check does not replace credentialed GitHub or marketplace validation.
