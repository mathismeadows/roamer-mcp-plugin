#!/usr/bin/env bash
# Roamer MCP — local stdio bridge.
#
# A thin stdio<->HTTP MCP proxy in front of the hosted Roamer MCP endpoint. The
# MCP client (Claude Code / Copilot / Desktop) speaks stdio to this script; the
# script relays each call to the hosted endpoint over plain HTTPS.
#
# Auth: two mechanisms, chosen per-machine by default-browser detection
# inside the invoked npm package (this wrapper script has no branching of its
# own). Safari-default machines (AUTH-25) use a server-mediated device
# authorization flow, since Cloudflare Access's Managed OAuth has no
# device-code grant of its own: RoamerMcp's server implements the RFC 8628
# shape itself, showing a short code + URL (+ QR code) and polling until
# sign-in completes, with no local port or TLS certificate involved. Every
# other machine (AUTH-14) uses a lighter direct loopback redirect against
# Cloudflare Access Managed OAuth instead.
#
# This replaces two prior, retired mechanisms: mcp-remote's Entra-direct
# loopback-redirect flow (AUTH-11) and this script's earlier Safari-specific
# Entra-direct device-code branch — both broke silently once Cloudflare
# Access enforcement replaced a prior bypass policy on this hostname, since
# neither ever went through Cloudflare's own OAuth flow.
#
# AUTH-24: this invokes the published, version-pinned @mathismeadows/roamer-
# device-auth npm package (source lives in roamer-mcp's own
# scripts/roamer-device-auth-package/, published via OIDC trusted
# publishing — no token) — this repo just invokes it, doesn't carry its source.
#
# Register with:
#   claude mcp add --scope user roamer -- /path/to/roamer-mcp-plugin/scripts/roamer-bridge.sh
#
# Requires Node (for npx). See README.md "Registering with the Claude Code CLI".
set -euo pipefail

exec npx -y @mathismeadows/roamer-device-auth@1.2.1
