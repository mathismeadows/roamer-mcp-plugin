#!/usr/bin/env bash
# Roamer MCP — local stdio bridge.
#
# A thin stdio<->HTTP MCP proxy (mcp-remote) in front of the hosted Roamer MCP
# endpoint. The MCP client (Claude Code / Copilot / Desktop) speaks stdio to this
# script; the script relays each call to the hosted endpoint through Cloudflare.
# The client never opens the HTTP connection itself, and a transient blip on the
# bridge->backend hop does not tear down the stdio MCP session.
#
# Auth: real per-user Entra ID login (OAuth, PKCE, public client — no secret to
# leak). mcp-remote opens a browser once, caches the resulting token under
# ~/.mcp-auth, and refreshes it silently after that. ROAMER_MCP_CLIENT_ID below
# is a public OAuth client ID (the RoamerMcp Entra app registration) — not a
# secret, safe to commit; a public client authenticates the human via their own
# Entra login, not via anything embedded in this script.
#
# The callback port is pinned (ROAMER_MCP_OAUTH_PORT) because Entra's "any port"
# localhost matching only applies to a bare http://localhost redirect URI (no
# port, no path); mcp-remote always appends /oauth/callback, so the exact
# http://localhost:38271/oauth/callback (and the 127.0.0.1 equivalent) is what's
# registered as a redirect URI on the app registration. If that port is ever
# busy, mcp-remote silently falls back to a random port and login fails with
# AADSTS50011 (redirect URI mismatch) — free the port and retry rather than
# registering a new URI for a moving target.
#
# --host 127.0.0.1: harmless either way (both hostnames are registered — see
# above) but keeps the constructed redirect URI as an IP literal.
#
# Safari-default clients skip the redirect flow entirely (see AUTH-14): WebKit's
# HTTPS-Only Mode unconditionally blocks plain http:// top-level navigation
# (scheme-based, not hostname-based — --host above doesn't help), so a browser
# whose default handler is Safari never gets a working loopback callback no
# matter what the redirect URI looks like. Detected via Launch Services below;
# routed to roamer-device-auth.mjs, which authenticates via the OAuth device-code
# grant instead — no local listener, no redirect URI, nothing for HTTPS-Only
# Mode to block.
#
# Register with:
#   claude mcp add --scope user roamer -- /path/to/roamer-mcp/scripts/roamer-bridge.sh
#
# Requires Node (for npx). See README.md "Registering with the Claude Code CLI".
#
# mcp-remote is pinned to 0.1.37: 0.1.38 added automatic RFC 8707 resource-
# indicator support, attaching the resource value discovered from
# /.well-known/oauth-protected-resource (this server's own Application ID URI)
# to every token refresh request. Because this app registration is both the
# OAuth client and the resource, Entra rejects that with AADSTS90009 ("is
# requesting a token for itself... supported only if resource is specified
# using the GUID based App Identifier"). An unpinned `npx -y mcp-remote` will
# silently pick up whatever's newest, so re-check this pin before bumping it.
#
# mcp-remote logs to stderr; stdout is reserved for the JSON-RPC protocol channel.
set -euo pipefail

# Prints the bundle ID of the OS's default handler for the "http" URL scheme,
# or "unknown" if it can't be determined. AUTH-14 routes on this: "com.apple.safari"
# takes the device-code path, anything else takes the existing redirect flow.
default_http_browser() {
  plutil -convert json -o - "$HOME/Library/Preferences/com.apple.LaunchServices/com.apple.launchservices.secure.plist" 2>/dev/null \
    | python3 -c '
import json, sys
try:
    data = json.load(sys.stdin)
except Exception:
    print("unknown")
    sys.exit(0)
for h in data.get("LSHandlers", []):
    if h.get("LSHandlerURLScheme") == "http":
        print(h.get("LSHandlerRoleAll", "unknown"))
        sys.exit(0)
print("unknown")
' 2>/dev/null || echo "unknown"
}

if [[ "${1:-}" == "--print-default-browser" ]]; then
  default_http_browser
  exit 0
fi

# The one place the endpoint URL lives. Override for a staging endpoint if needed.
ROAMER_MCP_URL="${ROAMER_MCP_URL:-https://roamer-mcp.mathismeadows.com/mcp}"
ROAMER_MCP_CLIENT_ID="${ROAMER_MCP_CLIENT_ID:-a55708ff-a990-4a06-afa8-d2fc86980b4e}"
ROAMER_MCP_OAUTH_PORT="${ROAMER_MCP_OAUTH_PORT:-38271}"

if [[ "$(default_http_browser)" == "com.apple.safari" ]]; then
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  if [[ ! -d "$SCRIPT_DIR/node_modules" ]]; then
    npm install --prefix "$SCRIPT_DIR" --silent >&2
  fi
  exec node "$SCRIPT_DIR/roamer-device-auth.mjs"
fi

exec npx -y mcp-remote@0.1.37 "$ROAMER_MCP_URL" "$ROAMER_MCP_OAUTH_PORT" \
  --static-oauth-client-info "{\"client_id\":\"${ROAMER_MCP_CLIENT_ID}\"}" \
  --host 127.0.0.1
