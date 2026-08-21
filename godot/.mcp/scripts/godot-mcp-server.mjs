#!/usr/bin/env node
// Godot MCP server (stdio) -> proxies commands to the in-game Godot MCP bridge
// (godot/mcp_bridge.gd) over TCP on 127.0.0.1:55139.
//
// Wire format to the bridge (see mcp_bridge.gd):
//   4-byte big-endian length prefix + UTF-8 JSON payload.
// Each tools/call opens a fresh TCP connection, sends one framed command,
// reads one framed response, and closes.
//
// MCP client (Hermes) talks to this process over stdio using newline-delimited
// JSON-RPC 2.0.

import net from "node:net";

const BRIDGE_HOST = "127.0.0.1";
const BRIDGE_PORT = 55139;
const SESSION_TOKEN = ""; // bridge has SESSION_TOKEN_BAKED="" => fail-open (no auth)

// ---- TCP bridge client -----------------------------------------------------

function sendBridgeCommand(command, extra = {}) {
  return new Promise((resolve, reject) => {
    const payload = JSON.stringify({ command, token: SESSION_TOKEN, ...extra });
    const buf = Buffer.from(payload, "utf8");
    const header = Buffer.alloc(4);
    header.writeUInt32BE(buf.length, 0);
    const frame = Buffer.concat([header, buf]);

    const socket = net.createConnection(BRIDGE_PORT, BRIDGE_HOST, () => {
      socket.write(frame);
    });

    let acc = Buffer.alloc(0);
    let expected = -1;
    let settled = false;

    const finish = (err, data) => {
      if (settled) return;
      settled = true;
      try { socket.destroy(); } catch (_) {}
      if (err) reject(err);
      else resolve(data);
    };

    socket.on("error", (e) => finish(e, null));
    socket.on("timeout", () => finish(new Error("bridge timeout"), null));
    socket.setTimeout(30000);

    socket.on("data", (chunk) => {
      acc = Buffer.concat([acc, chunk]);
      // Parse as many complete frames as available.
      while (true) {
        if (expected < 0) {
          if (acc.length < 4) return;
          expected = acc.readUInt32BE(0);
          acc = acc.subarray(4);
        }
        if (acc.length < expected) return;
        const body = acc.subarray(0, expected);
        acc = acc.subarray(expected);
        expected = -1;
        try {
          const text = body.toString("utf8").trim();
          const json = JSON.parse(text);
          finish(null, json);
          return;
        } catch (e) {
          finish(e, null);
          return;
        }
      }
    });
  });
}

// ---- MCP protocol (stdio, newline-delimited JSON-RPC 2.0) ------------------

const TOOLS = [
  {
    name: "ping",
    description: "Check that the Godot MCP bridge is alive. Returns project path + session token.",
    inputSchema: { type: "object", properties: {} },
  },
  {
    name: "screenshot",
    description: "Capture a screenshot of the running Godot game viewport. Returns a PNG file path.",
    inputSchema: {
      type: "object",
      properties: {
        preview_max_width: { type: "number", description: "Optional preview max width (px)." },
        preview_max_height: { type: "number", description: "Optional preview max height (px)." },
      },
    },
  },
  {
    name: "get_ui_elements",
    description: "Discover UI controls in the running game (buttons, labels, etc.).",
    inputSchema: {
      type: "object",
      properties: {
        visible_only: { type: "boolean", description: "Only return visible controls (default true)." },
        type_filter: { type: "string", description: "Optional Control class filter (e.g. 'Button')." },
      },
    },
  },
  {
    name: "input",
    description: "Simulate input in the game: keys, mouse buttons, motion, godot actions, UI element clicks, or waits.",
    inputSchema: {
      type: "object",
      properties: {
        actions: {
          type: "array",
          description: "Array of input action objects. Each has a 'type'.",
          items: { type: "object" },
        },
      },
      required: ["actions"],
    },
  },
  {
    name: "run_script",
    description: "Run a GDScript snippet in the live game via the bridge (advanced).",
    inputSchema: {
      type: "object",
      properties: {
        script: { type: "string", description: "GDScript source to execute." },
      },
      required: ["script"],
    },
  },
  {
    name: "shutdown",
    description: "Tell the Godot bridge / game to shut down.",
    inputSchema: { type: "object", properties: {} },
  },
];

function mcpResult(obj) {
  return { content: [{ type: "text", text: typeof obj === "string" ? obj : JSON.stringify(obj, null, 2) }] };
}

function toolCall(name, args) {
  switch (name) {
    case "ping":
      return sendBridgeCommand("ping").then(mcpResult);
    case "screenshot":
      return sendBridgeCommand("screenshot", {
        preview_max_width: args.preview_max_width ?? 0,
        preview_max_height: args.preview_max_height ?? 0,
      }).then(mcpResult);
    case "get_ui_elements":
      return sendBridgeCommand("get_ui_elements", {
        visible_only: args.visible_only ?? true,
        type_filter: args.type_filter ?? "",
      }).then(mcpResult);
    case "input":
      return sendBridgeCommand("input", { actions: args.actions ?? [] }).then(mcpResult);
    case "run_script":
      return sendBridgeCommand("run_script", { script: args.script ?? "" }).then(mcpResult);
    case "shutdown":
      return sendBridgeCommand("shutdown").then(mcpResult);
    default:
      return Promise.resolve({ content: [{ type: "text", text: JSON.stringify({ error: "Unknown tool: " + name }) }], isError: true });
  }
}

let buffer = "";

function handleMessage(msg) {
  const id = msg.id;
  const respond = (result) => {
    process.stdout.write(JSON.stringify({ jsonrpc: "2.0", id, result }) + "\n");
  };
  const respondError = (code, message) => {
    process.stdout.write(JSON.stringify({ jsonrpc: "2.0", id, error: { code, message } }) + "\n");
  };

  try {
    if (msg.method === "initialize") {
      respond({
        protocolVersion: "2024-11-05",
        capabilities: { tools: {} },
        serverInfo: { name: "godot-bridge-mcp", version: "1.0.0" },
      });
      return;
    }
    if (msg.method === "notifications/initialized") return;
    if (msg.method === "tools/list") {
      respond({ tools: TOOLS });
      return;
    }
    if (msg.method === "tools/call") {
      const name = msg.params?.name;
      const args = msg.params?.arguments ?? {};
      toolCall(name, args)
        .then((res) => respond({ content: res.content, isError: !!res.isError }))
        .catch((e) => respond({ content: [{ type: "text", text: "Bridge error: " + e.message }], isError: true }));
      return;
    }
    // Unknown method
    respondError(-32601, "Method not found: " + msg.method);
  } catch (e) {
    respondError(-32603, "Internal error: " + e.message);
  }
}

process.stdin.setEncoding("utf8");
process.stdin.on("data", (chunk) => {
  buffer += chunk;
  let nl;
  while ((nl = buffer.indexOf("\n")) >= 0) {
    const line = buffer.slice(0, nl).trim();
    buffer = buffer.slice(nl + 1);
    if (line.length === 0) continue;
    try {
      const msg = JSON.parse(line);
      handleMessage(msg);
    } catch (_) {
      // Ignore malformed lines.
    }
  }
});

// Keep process alive; flush stdout.
process.stdout.on("error", () => process.exit(1));
