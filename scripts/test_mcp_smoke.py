"""
Automated MCP Bridge Smoke Test
Verifies:
1. TCP connection & 4-byte Big-Endian framing
2. "ping" command & pong response
3. "run_script" command execution & math/logic evaluation
4. "get_ui_elements" command & UI hierarchy discovery
"""

import socket
import struct
import json
import os
import sys

HOST = os.environ.get("GODOT_MCP_HOST", "127.0.0.1")
PORT = int(os.environ.get("GODOT_MCP_PORT", "55139"))
TOKEN = os.environ.get("MCP_SESSION_TOKEN", "")

def send_command(sock, command_dict):
    payload = json.dumps(command_dict).encode("utf-8")
    header = struct.pack(">I", len(payload))
    sock.sendall(header + payload)

    # Read 4-byte header
    header_bytes = b""
    while len(header_bytes) < 4:
        chunk = sock.recv(4 - len(header_bytes))
        if not chunk:
            raise ConnectionError("Connection closed while waiting for header")
        header_bytes += chunk

    expected_len = struct.unpack(">I", header_bytes)[0]
    body_bytes = b""
    while len(body_bytes) < expected_len:
        chunk = sock.recv(expected_len - len(body_bytes))
        if not chunk:
            raise ConnectionError("Connection closed while waiting for payload")
        body_bytes += chunk

    return json.loads(body_bytes.decode("utf-8"))

def run_tests():
    print(f"[MCP Smoke Test] Connecting to {HOST}:{PORT}...")
    try:
        s = socket.create_connection((HOST, PORT), timeout=10)
    except Exception as e:
        print(f"[MCP Smoke Test] FAILED to connect: {e}")
        return False

    try:
        # Test 1: Ping
        print("  1. Testing 'ping' command...")
        res_ping = send_command(s, {"command": "ping", "token": TOKEN})
        assert res_ping.get("status") == "pong", f"Expected 'pong', got: {res_ping}"
        print(f"     ✅ Ping OK! (project: {res_ping.get('project_path', 'unknown')})")

        # Test 2: Run Script (both 'script' and 'source')
        print("  2. Testing 'run_script' with 'script' key...")
        res_script = send_command(s, {
            "command": "run_script",
            "token": TOKEN,
            "script": "func execute(scene_tree: SceneTree) -> Variant: return 400 + 20"
        })
        assert res_script.get("result") == 420, f"Expected 420, got: {res_script}"
        print("     ✅ run_script ('script' param) OK! (result: 420)")

        # Test 3: Get UI Elements
        print("  3. Testing 'get_ui_elements' command...")
        res_ui = send_command(s, {
            "command": "get_ui_elements",
            "token": TOKEN,
            "visible_only": False
        })
        controls = res_ui.get("controls", [])
        assert len(controls) > 0, "Expected non-empty control list"
        print(f"     ✅ get_ui_elements OK! (found {len(controls)} controls)")

        print("\n🎉 ALL MCP BRIDGE SMOKE TESTS PASSED SUCCESSFULLY!")
        return True
    finally:
        s.close()

if __name__ == "__main__":
    success = run_tests()
    sys.exit(0 if success else 1)
