#!/usr/bin/env bash
# Roamer MCP — local stdio bridge.
#
# A thin stdio<->HTTP MCP proxy in front of the hosted Roamer MCP endpoint. The
# MCP client (Claude Code / Copilot / Desktop) speaks stdio to this script; the
# script relays each call to the hosted endpoint over plain HTTPS.
#
# Auth: AUTH-25, a server-mediated device authorization flow — the same
# mechanism for every OS and every default browser, no branching needed here
# at all. Cloudflare Access's Managed OAuth has no device-code grant of its
# own (confirmed live 2026-08-20 — device authentication is not supported for
# MCP portals), so RoamerMcp's server implements the RFC 8628 shape itself:
# this script calls RoamerMcp's own /oauth/device/* endpoints over plain
# HTTPS, shows the user a short code + URL (+ QR code), and polls until
# sign-in completes. No local port is ever opened, no local TLS certificate
# is ever involved — which is what makes this work identically regardless of
# the OS's default http handler.
#
# This replaces two prior, now-retired mechanisms: mcp-remote's Entra-direct
# loopback-redirect flow (AUTH-11) and this script's own previous
# Safari-specific Entra-direct device-code branch (AUTH-14) — both broke
# silently on 2026-07-26 when Cloudflare Access's Bypass=Everyone policy on
# this hostname was replaced with real enforcement (AUTH-20..23), since
# neither ever went through Cloudflare's own OAuth flow. See AUTH-25/26 for
# the full incident writeup.
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

exec npx -y @mathismeadows/roamer-device-auth@1.2.0
