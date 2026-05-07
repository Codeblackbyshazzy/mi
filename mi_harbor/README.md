# Harbor Integration for mi

Run mi against Terminal-Bench 2.0 and other Harbor-supported benchmarks.

## Prerequisites

```bash
uv tool install harbor
```

## Quick Start

**Local LLM (llama.cpp, vllm, ollama):**
```bash
./run-local.sh                    # all 89 tasks
./run-local.sh --n-tasks 5        # 5 tasks
```

**Quick validation (3 tasks):**
```bash
./run-subset.sh
```

## Running Terminal-Bench 2.0 manually

```bash
export PYTHONPATH=/path/to/mi
export OPENAI_API_KEY=dummy
export OPENAI_BASE_URL=http://localhost:33831

harbor run \
  --dataset terminal-bench@2.0 \
  --agent-import-path mi_harbor.mi_agent:MiAgent \
  --model openai/unsloth/Qwen3.6-35B-A3B-GGUF:Q4_K_XL \
  --n-concurrent 1 \
  --n-tasks 3
```

## Environment Variables

| Variable | Description |
|----------|-------------|
| `OPENAI_API_KEY` | Required. API key for the model provider (use `dummy` for local). |
| `OPENAI_BASE_URL` | API endpoint (default: `http://localhost:33831`). |
| `MODEL` | Model to use (default: `unsloth/Qwen3.6-35B-A3B-GGUF:Q4_K_XL`). |
| `PYTHONPATH` | Must include the mi repo root for harbor to find `mi_harbor.mi_agent`. |

## Cloud Providers

For larger-scale evaluation, use Daytona or Modal:

```bash
export OPENAI_API_KEY=<your-key>
export DAYTONA_API_KEY=<your-key>

harbor run \
  --dataset terminal-bench@2.0 \
  --agent-import-path mi_harbor.mi_agent:MiAgent \
  --model openai/gpt-5.4 \
  --n-concurrent 100 \
  --env daytona
```

## Networking Note

When using a local LLM server, the agent rewrites `localhost` URLs to `172.17.0.1` (Docker bridge gateway) so the container can reach the host. If your LLM server binds only to 127.0.0.1, you may need to reconfigure it to listen on all interfaces or the Docker bridge IP.

## Diagnostics

The adapter captures diagnostic information to debug failure modes:

**Log files** (in each trial's `agent/` directory):
- `mi-output.txt` — Timestamped stdout (each line prefixed with elapsed seconds)
- `mi-stderr.txt` — Timestamped stderr
- `timing.txt` — Start/end timestamps and exit code
- `diagnostics.txt` — Pre-flight LLM check, post-mortem network diagnostics

**Example diagnostic output:**
```
[2026-04-28T10:45:00+00:00] === MI AGENT START ===
[2026-04-28T10:45:00+00:00] LLM endpoint: http://172.17.0.1:33831
[2026-04-28T10:45:00+00:00] Model: unsloth/Qwen3.6-35B-A3B-GGUF:Q4_K_XL
[2026-04-28T10:45:00+00:00] Pre-flight LLM connectivity check...
[2026-04-28T10:45:01+00:00] Pre-flight completed: HTTP 200 in 0.523s
[2026-04-28T10:45:01+00:00] Starting mi agent...
...
[2026-04-28T11:45:01+00:00] MI agent finished with exit code 0 after 3600.12s
[2026-04-28T11:45:01+00:00] === POST-MORTEM DIAGNOSTICS ===
[2026-04-28T11:45:01+00:00] Output lines: 65
[2026-04-28T11:45:01+00:00] Post-mortem LLM check...
[2026-04-28T11:45:02+00:00] Post-mortem LLM status: HTTP 200
```

This helps diagnose:
- **LLM unreachable** — Pre-flight check fails
- **LLM went down mid-task** — Pre-flight OK, post-mortem fails
- **Hung requests** — Timestamps show gap between last output line and timeout
- **Network issues** — Post-mortem ping fails

## Limitations

- mi doesn't produce structured trajectory logs (ATIF), so detailed step-by-step analysis isn't available
- Token counting is approximate (based on output word count)

## Other Benchmarks

```bash
# List available benchmarks
harbor datasets list

# Run against SWE-bench
PYTHONPATH=/path/to/mi harbor run \
  -d swe-bench-verified \
  --agent-import-path mi_harbor.mi_agent:MiAgent \
  -m openai/gpt-5.4
```
