#!/usr/bin/env bash
# Roamer MCP — local stdio bridge.
#
# A thin stdio<->HTTP MCP proxy in front of the hosted Roamer MCP endpoint. The
# MCP client (Claude Code / Copilot / Desktop) speaks stdio to this script; the
# script relays each call to the hosted endpoint over plain HTTPS.
#
# Auth: two mechanisms, chosen per-machine by default-browser detection
# inside the invoked npm package (this wrapper script has no branching of its
# own), both against RoamerMcp's own OAuth authorization server. Safari-default
# machines use a server-mediated device authorization flow, since Safari's
# HTTPS-Only Mode blocks a plain loopback redirect: RoamerMcp's server
# implements the RFC 8628 shape itself, showing a short code + URL (+ QR code)
# and polling until sign-in completes, with no local port or TLS certificate
# involved. Every other machine uses a lighter direct loopback redirect
# instead.
#
# This replaces two prior, retired mechanisms: mcp-remote's Entra-direct
# loopback-redirect flow and this script's earlier Safari-specific Entra-
# direct device-code branch — both broke silently once Cloudflare Access
# enforcement replaced a prior bypass policy on this hostname, since neither
# ever went through Cloudflare's own OAuth flow.
#
# This invokes the published @mathismeadows/roamer-device-auth npm package
# (source lives in roamer-mcp's own scripts/roamer-device-auth-package/,
# published via OIDC trusted publishing — no token) — this repo just invokes
# it, doesn't carry its source.
#
# Deliberately UNPINNED (no @version suffix) — RELEASE-bridge-multi-surface-drift:
# an exact pin meant every bridge-only npm release also needed a coordinated
# commit in this repo (bump this pin + plugin.json's version together, per
# AUTH-51/AUTH-52's own rollouts) before any installed plugin could pick it
# up. Unpinned, npx resolves whatever's currently published as `latest` on
# every fresh invocation — a new bridge release is live everywhere the next
# time a session restarts, no touch needed here at all. Matches the pattern
# other mature plugins in this same marketplace ecosystem already use for
# their own bundled MCP servers (e.g. nutmeg's `npx -y football-docs`).
# Tradeoff, accepted deliberately: this repo can no longer pin a specific
# bridge version known-good against the current RoamerMcp server — a future
# bridge change that needs a not-yet-deployed server feature would reach
# every client immediately. Bump this back to an exact pin if that class of
# change is ever needed.
#
# Register with:
#   claude mcp add --scope user roamer -- /path/to/roamer-mcp-plugin/scripts/roamer-bridge.sh
#
# Requires Node (for npx). See README.md "Registering with the Claude Code CLI".
set -euo pipefail

exec npx -y @mathismeadows/roamer-device-auth
