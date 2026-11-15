#!/usr/bin/env python3
"""
RevoltOS AI CLI Interface (revolt-ai)
Direct command-line interaction with revoltd and local Ollama.
"""

import sys
import json
import argparse
import urllib.request
import urllib.error


def main():
    parser = argparse.ArgumentParser(
        prog="revolt-ai",
        description="RevoltOS Native AI Assistant (Local Ollama & Developer Intelligence)"
    )
    parser.add_argument("prompt", nargs="*", help="Query or prompt to ask Revolt AI")
    parser.add_argument("--diagnose", "-d", help="Path to error log or string to diagnose")
    parser.add_argument("--git-commit", "-g", action="store_true", help="Generate git commit message from staged changes")
    parser.add_argument("--status", "-s", action="store_true", help="Check revoltd and local model status")
    parser.add_argument("--model", "-m", help="Specific model name (default: qwen2.5-coder:1.5b)")

    args = parser.parse_args()

    base_url = "http://127.0.0.1:18070"

    if args.status:
        try:
            req = urllib.request.Request(f"{base_url}/v1/status")
            with urllib.request.urlopen(req, timeout=2.0) as resp:
                data = json.loads(resp.read().decode())
                print(json.dumps(data, indent=2))
        except Exception as e:
            print(f"[-] revoltd is not reachable ({e}). Run: python3 -m revolt_ai.backend.server &")
        return

    if args.git_commit:
        try:
            payload = json.dumps({"path": "."}).encode()
            req = urllib.request.Request(f"{base_url}/v1/tools/git-commit", data=payload, headers={"Content-Type": "application/json"})
            with urllib.request.urlopen(req, timeout=5.0) as resp:
                data = json.loads(resp.read().decode())
                print("\nProposed Commit Message:\n" + "-" * 40)
                print(data.get("commit_message", ""))
                print("-" * 40)
        except Exception as e:
            print(f"[-] Error querying git commit tool: {e}")
        return

    if args.diagnose:
        log_content = args.diagnose
        # If it's a file, read it
        try:
            with open(args.diagnose, "r") as f:
                log_content = f.read()
        except Exception:
            pass

        try:
            payload = json.dumps({"log": log_content}).encode()
            req = urllib.request.Request(f"{base_url}/v1/tools/diagnose", data=payload, headers={"Content-Type": "application/json"})
            with urllib.request.urlopen(req, timeout=5.0) as resp:
                data = json.loads(resp.read().decode())
                print("\n" + "=" * 50)
                print("           Revolt AI Error Diagnosis              ")
                print("=" * 50)
                print(f"Error Type    : {data.get('error_type')}")
                print(f"Suggested Fix : {data.get('suggested_fix')}")
                print("=" * 50 + "\n")
        except Exception as e:
            print(f"[-] Diagnosis error: {e}")
        return

    query = " ".join(args.prompt).strip()
    if not query:
        parser.print_help()
        return

    print(f"\n[Revolt AI] Querying: {query}...\n")
    try:
        payload = json.dumps({"prompt": query, "model": args.model}).encode()
        req = urllib.request.Request(f"{base_url}/v1/chat", data=payload, headers={"Content-Type": "application/json"})
        with urllib.request.urlopen(req, timeout=120.0) as resp:
            # Handle streaming SSE or single JSON response
            content_type = resp.headers.get("Content-Type", "")
            if "text/event-stream" in content_type:
                for line in resp:
                    if line:
                        line_str = line.decode("utf-8").strip()
                        if line_str.startswith("data: "):
                            data_chunk = line_str[6:]
                            if data_chunk == "[DONE]":
                                break
                            try:
                                chunk = json.loads(data_chunk)
                                sys.stdout.write(chunk.get("token", ""))
                                sys.stdout.flush()
                            except Exception:
                                pass
                print("\n")
            else:
                data = json.loads(resp.read().decode())
                print(data.get("response", ""))
    except Exception as e:
        print(f"[-] Error communicating with revoltd: {e}")


if __name__ == "__main__":
    main()
