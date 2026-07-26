#!/usr/bin/env node
// Roamer MCP — device-code auth path (AUTH-14).
//
// Used instead of roamer-bridge.sh's normal mcp-remote/loopback-redirect flow
// when the OS's default browser is Safari. Safari's HTTPS-Only Mode blocks
// ANY plain http:// top-level navigation, so a loopback redirect callback
// (http://127.0.0.1:<port>/oauth/callback) never works there no matter what
// the redirect URI looks like — see AUTH-14 and the roamer-bridge.sh comments.
//
// The OAuth 2.0 Device Authorization Grant sidesteps the problem entirely:
// there is no redirect URI and no local listener at all. The user visits a
// real https://microsoft.com page and types a short code; this process polls
// Entra's token endpoint until that completes. Independent of mcp-remote —
// this file owns its own token cache and its own stdio<->HTTP MCP proxying
// (via the official @modelcontextprotocol/sdk), rather than assuming anything
// about mcp-remote's on-disk format.
//
// stdout is reserved for the JSON-RPC protocol channel; all logging goes to
// stderr, matching the convention in roamer-bridge.sh / mcp-remote.
//
// The verification URL + user code are also shown via a native macOS dialog
// (osascript), not just logged to stderr: this script normally runs as an MCP
// host's spawned stdio subprocess, and hosts are not obligated to surface a
// child process's stderr anywhere visible — confirmed by hitting exactly that
// with a stderr-only first version of this file. Entra's device-code response
// has no verification_uri_complete (pre-filled-code URL) field, so the code
// can only be conveyed as text; the dialog is what makes that text guaranteed
// visible, the same way the redirect flow's login prompt is inherently
// visible by virtue of a real browser window opening.

import { StreamableHTTPClientTransport } from "@modelcontextprotocol/sdk/client/streamableHttp.js";
import { readFile, writeFile, mkdir } from "node:fs/promises";
import { homedir } from "node:os";
import { join } from "node:path";
import { setTimeout as sleep } from "node:timers/promises";
import { execFile } from "node:child_process";
import { promisify } from "node:util";

const execFileAsync = promisify(execFile);

const ROAMER_MCP_URL = process.env.ROAMER_MCP_URL ?? "https://roamer-mcp.mathismeadows.com/mcp";
const ROAMER_MCP_CLIENT_ID = process.env.ROAMER_MCP_CLIENT_ID ?? "a55708ff-a990-4a06-afa8-d2fc86980b4e";
const ROAMER_MCP_TENANT_ID = process.env.ROAMER_MCP_TENANT_ID ?? "6099dc20-e8a0-4925-b68d-b9d267e01cff";
const SCOPE = "https://roamer-mcp.mathismeadows.com/mcp/mcp.access offline_access";

const AUTHORITY = `https://login.microsoftonline.com/${ROAMER_MCP_TENANT_ID}/oauth2/v2.0`;
const CACHE_DIR = join(homedir(), ".mcp-auth-device");
const CACHE_FILE = join(CACHE_DIR, "roamer_tokens.json");

function log(message) {
  process.stderr.write(`[roamer-device-auth] ${message}\n`);
}

// stderr text alone is not a reliable way to reach the user: this process is
// typically spawned as an MCP host's stdio subprocess, and hosts are not
// obligated to surface a child process's stderr anywhere a human will see it
// (confirmed — a host running this exact script did not). A native dialog is
// an OS-level surface, guaranteed visible independent of what the host does
// with stderr, mirroring how the redirect flow's visibility never depended on
// stderr either (a real browser window opening is its own visible side effect).
async function showDeviceCodeDialog(verificationUri, userCode) {
  const message = `Sign in to Roamer MCP:\n\n1. Go to ${verificationUri}\n2. Enter code: ${userCode}`;
  const script = `display dialog "${message.replace(/"/g, '\\"')}" with title "Roamer MCP Sign-In" buttons {"OK"} default button "OK"`;
  try {
    await execFileAsync("osascript", ["-e", script]);
  } catch {
    // Best-effort only — the code is still in the fatal-error-free stderr log
    // above for anyone who does have visibility into it.
  }
}

async function readCachedTokens() {
  try {
    return JSON.parse(await readFile(CACHE_FILE, "utf8"));
  } catch {
    return null;
  }
}

async function writeCachedTokens(tokens) {
  await mkdir(CACHE_DIR, { recursive: true, mode: 0o700 });
  await writeFile(CACHE_FILE, JSON.stringify(tokens, null, 2), { mode: 0o600 });
}

async function requestDeviceCode() {
  const body = new URLSearchParams({ client_id: ROAMER_MCP_CLIENT_ID, scope: SCOPE });
  const response = await fetch(`${AUTHORITY}/devicecode`, {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body,
  });
  if (!response.ok) {
    throw new Error(`Device code request failed: ${response.status} ${await response.text()}`);
  }
  return response.json();
}

async function pollForToken(deviceCode, intervalSeconds) {
  let interval = intervalSeconds;
  const body = new URLSearchParams({
    grant_type: "urn:ietf:params:oauth:grant-type:device_code",
    device_code: deviceCode,
    client_id: ROAMER_MCP_CLIENT_ID,
  });
  for (;;) {
    await sleep(interval * 1000);
    const response = await fetch(`${AUTHORITY}/token`, {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded" },
      body,
    });
    const data = await response.json();
    if (response.ok) {
      return data;
    }
    if (data.error === "authorization_pending") {
      continue;
    }
    if (data.error === "slow_down") {
      interval += 5;
      continue;
    }
    throw new Error(`Device code login failed: ${data.error} — ${data.error_description ?? ""}`);
  }
}

async function refreshTokens(refreshToken) {
  // Deliberately scope-based (not resource-based) — see the AADSTS90009 note
  // in roamer-bridge.sh for why a resource-indicator refresh fails against
  // this app registration.
  const body = new URLSearchParams({
    grant_type: "refresh_token",
    refresh_token: refreshToken,
    client_id: ROAMER_MCP_CLIENT_ID,
    scope: SCOPE,
  });
  const response = await fetch(`${AUTHORITY}/token`, {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body,
  });
  if (!response.ok) {
    throw new Error(`Token refresh failed: ${response.status} ${await response.text()}`);
  }
  return response.json();
}

function expiresSoon(tokens) {
  const obtainedAt = tokens.obtained_at ?? 0;
  const expiresAt = obtainedAt + (tokens.expires_in ?? 0) * 1000;
  return Date.now() > expiresAt - 60_000; // refresh a minute early
}

async function getValidTokens() {
  let tokens = await readCachedTokens();

  if (tokens && !expiresSoon(tokens)) {
    return tokens;
  }

  if (tokens?.refresh_token) {
    try {
      log("Refreshing cached token...");
      const fresh = await refreshTokens(tokens.refresh_token);
      tokens = { ...fresh, obtained_at: Date.now() };
      await writeCachedTokens(tokens);
      return tokens;
    } catch (err) {
      log(`Refresh failed (${err.message}), falling back to device-code login.`);
    }
  }

  log("Starting device-code login...");
  const device = await requestDeviceCode();
  log(`Go to ${device.verification_uri} and enter code: ${device.user_code}`);
  // Fire-and-forget: the dialog is how the human actually sees this (see
  // showDeviceCodeDialog above); polling below must not wait on it being
  // dismissed.
  showDeviceCodeDialog(device.verification_uri, device.user_code);
  try {
    const { default: open } = await import("open");
    await open(device.verification_uri);
  } catch {
    // Best-effort only — the dialog above already carries the URL and code.
  }
  const fresh = await pollForToken(device.device_code, device.interval ?? 5);
  tokens = { ...fresh, obtained_at: Date.now() };
  await writeCachedTokens(tokens);
  log("Login complete.");
  return tokens;
}

async function main() {
  let tokens = await getValidTokens();

  const transport = new StreamableHTTPClientTransport(new URL(ROAMER_MCP_URL), {
    requestInit: {
      get headers() {
        return { Authorization: `Bearer ${tokens.access_token}` };
      },
    },
  });

  transport.onerror = (err) => log(`Transport error: ${err.message}`);
  await transport.start();
  log("Connected to remote server using StreamableHTTPClientTransport.");

  // stdin/stdout <-> transport pass-through. Each stdin line is one JSON-RPC
  // message; transport.send() delivers it, and transport.onmessage delivers
  // whatever comes back (including server-initiated messages over the
  // SSE half of the streamable-HTTP transport).
  transport.onmessage = (message) => {
    process.stdout.write(`${JSON.stringify(message)}\n`);
  };

  let buffer = "";
  process.stdin.setEncoding("utf8");
  process.stdin.on("data", (chunk) => {
    buffer += chunk;
    let newlineIndex;
    while ((newlineIndex = buffer.indexOf("\n")) !== -1) {
      const line = buffer.slice(0, newlineIndex);
      buffer = buffer.slice(newlineIndex + 1);
      if (!line.trim()) continue;
      (async () => {
        try {
          if (expiresSoon(tokens)) {
            tokens = await getValidTokens();
          }
          await transport.send(JSON.parse(line));
        } catch (err) {
          log(`Send failed: ${err.message}`);
        }
      })();
    }
  });

  process.stdin.on("end", async () => {
    log("stdin closed, shutting down.");
    await transport.close();
    process.exit(0);
  });

  log("Local STDIO proxy running. Press Ctrl+C to exit.");
}

main().catch((err) => {
  log(`Fatal error: ${err.stack ?? err.message}`);
  process.exit(1);
});
