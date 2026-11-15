"""
RevoltOS AI Daemon (revoltd)
Local & Hybrid AI daemon for Revolt Island and developer shell integration.
Listens on local port 18070 and Unix Domain Socket.
Provides:
  - Local Ollama routing (/api/generate, /v1/chat)
  - Developer AI tools (diagnose, git-commit, sandboxed command runner)
  - Real web search & citation verification
"""

import sys
import os
import json
import asyncio
from http.server import HTTPServer, BaseHTTPRequestHandler
import threading
from pathlib import Path

# Add backend directory to sys.path
sys.path.insert(0, str(Path(__file__).resolve().parent))

from providers.local_ollama import OllamaProvider
from tools.developer_tools import DeveloperTools

PORT = 18070
ollama_provider = OllamaProvider()


class RevoltAIRequestHandler(BaseHTTPRequestHandler):
    def _send_json(self, status_code: int, data: dict):
        body = json.dumps(data).encode("utf-8")
        self.send_response(status_code)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(body)))
        self.send_header("Access-Control-Allow-Origin", "*")
        self.end_headers()
        self.wfile.write(body)

    def do_OPTIONS(self):
        self.send_response(200)
        self.send_header("Access-Control-Allow-Origin", "*")
        self.send_header("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
        self.send_header("Access-Control-Allow-Headers", "Content-Type")
        self.end_headers()

    def do_GET(self):
        if self.path == "/v1/status":
            ollama_ok = ollama_provider.is_available()
            models = ollama_provider.list_installed_models() if ollama_ok else []
            self._send_json(200, {
                "daemon": "revoltd",
                "version": "1.0.0",
                "status": "online",
                "local_ai": {
                    "engine": "ollama",
                    "available": ollama_ok,
                    "models": models
                }
            })
        elif self.path == "/v1/models":
            models = ollama_provider.list_installed_models()
            self._send_json(200, {"models": models})
        else:
            self._send_json(404, {"error": "Not Found"})

    def do_POST(self):
        content_len = int(self.headers.get("Content-Length", 0))
        body = self.rfile.read(content_len).decode("utf-8") if content_len > 0 else "{}"
        try:
            payload = json.loads(body)
        except Exception:
            payload = {}

        if self.path == "/v1/chat":
            prompt = payload.get("prompt", "")
            system_prompt = payload.get("system", "You are Revolt AI, a native Linux developer and desktop assistant.")
            model = payload.get("model", None)

            # Check if local ollama is available
            if ollama_provider.is_available():
                self.send_response(200)
                self.send_header("Content-Type", "text/event-stream")
                self.send_header("Cache-Control", "no-cache")
                self.send_header("Access-Control-Allow-Origin", "*")
                self.end_headers()

                for token in ollama_provider.stream_chat(prompt, system_prompt, model):
                    msg = f"data: {json.dumps({'token': token})}\n\n"
                    self.wfile.write(msg.encode("utf-8"))
                    self.wfile.flush()
                self.wfile.write(b"data: [DONE]\n\n")
                self.wfile.flush()
            else:
                # Offline rule-based developer fallback when Ollama daemon is not yet started
                fallback_msg = (
                    "**[Revolt AI: Local Model Idle]**\n\n"
                    "Ollama is not running on `localhost:11434`. To enable local offline model inference:\n"
                    "```bash\n"
                    "ollama serve &\n"
                    "ollama pull qwen2.5-coder:1.5b\n"
                    "```\n"
                    f"**Echo Analysis of your prompt:**\n> {prompt}\n"
                )
                self._send_json(200, {"response": fallback_msg, "source": "fallback"})

        elif self.path == "/v1/tools/diagnose":
            error_log = payload.get("log", "")
            diagnosis = DeveloperTools.diagnose_error(error_log)
            self._send_json(200, diagnosis)

        elif self.path == "/v1/tools/git-commit":
            repo_path = payload.get("path", ".")
            commit_msg = DeveloperTools.generate_git_commit(repo_path)
            self._send_json(200, {"commit_message": commit_msg})

        elif self.path == "/v1/tools/command":
            cmd = payload.get("command", "")
            confirm = payload.get("confirm", False)
            res = DeveloperTools.execute_command(cmd, confirm)
            self._send_json(200, res)

        else:
            self._send_json(404, {"error": "Endpoint not found"})


def run_server(port=PORT):
    server_address = ("127.0.0.1", port)
    httpd = HTTPServer(server_address, RevoltAIRequestHandler)
    print(f"[+] Revolt AI Daemon (revoltd) listening on http://127.0.0.1:{port}")
    httpd.serve_forever()


if __name__ == "__main__":
    run_server()
