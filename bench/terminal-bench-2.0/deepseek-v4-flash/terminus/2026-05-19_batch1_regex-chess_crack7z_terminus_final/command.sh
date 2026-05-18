#!/bin/bash
# Exact launch for iter1 batch1 2 tasks (regex-chess + crack-7z-hash) under terminus-2
# (launched via nohup in timeboxed eval iter 1, finished ~01:45 with real results)
export OPENAI_API_KEY=...from-hermes...
/home/everlier/.local/bin/uv tool uvx --from harbor harbor run --dataset terminal-bench@2.0 --agent terminus-2 --model openai/deepseek/deepseek-v4-flash --n-concurrent 2 --n-tasks 2 --yes --include-task-name regex-chess --include-task-name crack-7z-hash --jobs-dir /tmp/mi-30-eval-iter1/terminus
