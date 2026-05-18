#!/usr/bin/env bash
set -euo pipefail
mkdir -p /tmp/mi-30-eval-iter4/mi /tmp/mi-30-eval-iter4/terminus
(
  export OPENAI_API_KEY="$(grep '^OPENROUTER_API_KEY=' ~/.hermes/.env 2>/dev/null | cut -d= -f2- || echo '')"
  export OPENAI_BASE_URL=https://openrouter.ai/api/v1
  export PYTHONPATH=/home/everlier/code/mi
  echo "=== Launching Batch 4 (3 tasks: chess-best-move openssl-selfsigned-cert train-fasttext) at $(date) ===" | tee -a /tmp/mi-30-eval-iter4-launch.log
  echo "Tasks chosen for diversity (games/chess, crypto/security, ML/training) from the 30-task preset list, not overlapping prior batches (regex-chess/crack-7z-hash, fix-git/db-wal/path-tracing/polyglot-c-py, largest-eigenval/mcmc/hf-model/qemu/configure-git-webserver). Load-safe addition given current ~9 active containers and some completions in iter2." | tee -a /tmp/mi-30-eval-iter4-launch.log

  echo "Launching mi side (adapter, n-concurrent=1)..." | tee -a /tmp/mi-30-eval-iter4-launch.log
  nohup /home/everlier/.local/bin/uv tool uvx --from harbor harbor run \
    --dataset terminal-bench@2.0 \
    --agent-import-path mi_harbor.mi_agent:MiAgent \
    --model openai/deepseek/deepseek-v4-flash \
    --n-concurrent 1 \
    --n-tasks 3 \
    --yes \
    --include-task-name chess-best-move \
    --include-task-name openssl-selfsigned-cert \
    --include-task-name train-fasttext \
    --jobs-dir /tmp/mi-30-eval-iter4/mi \
    >> /tmp/mi-30-eval-iter4-mi.log 2>&1 &
  MI_PARENT=$!
  echo $MI_PARENT > /tmp/mi-30-eval-iter4-mi-parent.pid
  sleep 10
  MI_PID=$(ps -ef | grep 'harbor run' | grep -F '/tmp/mi-30-eval-iter4/mi' | grep -v grep | awk '{print $2}' | head -1 || true)
  if [[ -n "${MI_PID}" ]]; then
    echo "$MI_PID" > /tmp/mi-30-eval-iter4-mi.pid
    echo "  mi python PID captured: $MI_PID" | tee -a /tmp/mi-30-eval-iter4-launch.log
  fi
  echo "  mi parent launcher PID: $MI_PARENT" | tee -a /tmp/mi-30-eval-iter4-launch.log

  echo "Launching terminus-2 side (n-concurrent=2)..." | tee -a /tmp/mi-30-eval-iter4-launch.log
  nohup /home/everlier/.local/bin/uv tool uvx --from harbor harbor run \
    --dataset terminal-bench@2.0 \
    --agent terminus-2 \
    --model openai/deepseek/deepseek-v4-flash \
    --n-concurrent 2 \
    --n-tasks 3 \
    --yes \
    --include-task-name chess-best-move \
    --include-task-name openssl-selfsigned-cert \
    --include-task-name train-fasttext \
    --jobs-dir /tmp/mi-30-eval-iter4/terminus \
    >> /tmp/mi-30-eval-iter4-terminus.log 2>&1 &
  TERM_PARENT=$!
  echo $TERM_PARENT > /tmp/mi-30-eval-iter4-terminus-parent.pid
  sleep 10
  TERM_PID=$(ps -ef | grep 'harbor run' | grep -F '/tmp/mi-30-eval-iter4/terminus' | grep -v grep | awk '{print $2}' | head -1 || true)
  if [[ -n "${TERM_PID}" ]]; then
    echo "$TERM_PID" > /tmp/mi-30-eval-iter4-terminus.pid
    echo "  terminus python PID captured: $TERM_PID" | tee -a /tmp/mi-30-eval-iter4-launch.log
  fi
  echo "  terminus parent launcher PID: $TERM_PARENT" | tee -a /tmp/mi-30-eval-iter4-launch.log

  echo "=== Batch 4 launched successfully. Use /tmp/mi-30-eval-iter4-*.pid and logs for monitoring. ===" | tee -a /tmp/mi-30-eval-iter4-launch.log
) 2>&1 | tee -a /tmp/mi-30-eval-iter4-launch.log
echo "Launch script completed (bg jobs detached)."