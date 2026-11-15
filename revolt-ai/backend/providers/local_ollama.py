"""
RevoltOS Local AI Engine - Ollama Provider Adapter
Integrates directly with local Ollama runtime (http://127.0.0.1:11434).
Zero-cloud offline inference for privacy, speed, and coding assistance.
"""

import json
import urllib.request
import urllib.error
from typing import AsyncGenerator, Dict, List, Optional


class OllamaProvider:
    def __init__(self, base_url: str = "http://127.0.0.1:11434", default_model: str = "qwen2.5-coder:1.5b"):
        self.base_url = base_url.rstrip("/")
        self.default_model = default_model

    def is_available(self) -> bool:
        """Checks if the local Ollama daemon is reachable."""
        try:
            req = urllib.request.Request(f"{self.base_url}/api/tags", headers={"User-Agent": "revoltd"})
            with urllib.request.urlopen(req, timeout=1.5) as resp:
                return resp.status == 200
        except Exception:
            return False

    def list_installed_models(self) -> List[str]:
        """Returns list of models installed in local Ollama storage."""
        try:
            req = urllib.request.Request(f"{self.base_url}/api/tags", headers={"User-Agent": "revoltd"})
            with urllib.request.urlopen(req, timeout=2.0) as resp:
                data = json.loads(resp.read().decode())
                return [m["name"] for m in data.get("models", [])]
        except Exception:
            return []

    def stream_chat(self, prompt: str, system_prompt: Optional[str] = None, model: Optional[str] = None):
        """
        Synchronous generator yielding streaming text tokens from Ollama.
        """
        chosen_model = model or self.default_model
        installed = self.list_installed_models()

        # If chosen model is not yet pulled, pick the first available local model or fallback
        if chosen_model not in installed and installed:
            chosen_model = installed[0]

        payload = {
            "model": chosen_model,
            "prompt": prompt,
            "stream": True
        }
        if system_prompt:
            payload["system"] = system_prompt

        req_data = json.dumps(payload).encode("utf-8")
        req = urllib.request.Request(
            f"{self.base_url}/api/generate",
            data=req_data,
            headers={"Content-Type": "application/json", "User-Agent": "revoltd"},
            method="POST"
        )

        try:
            with urllib.request.urlopen(req, timeout=60.0) as resp:
                for line in resp:
                    if line:
                        chunk = json.loads(line.decode("utf-8"))
                        token = chunk.get("response", "")
                        yield token
                        if chunk.get("done", False):
                            break
        except Exception as e:
            yield f"\n[Local AI Error: Failed to connect to Ollama on {self.base_url} ({str(e)})]"
