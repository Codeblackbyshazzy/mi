#!/bin/bash
# Exact launch for batch2 4 tasks (fix-git, db-wal-recovery, path-tracing, polyglot-c-py) under mi adapter
# (launched ~01:34 via nohup in timeboxed eval iter2; at snapshot ~01:48: 3/4 completed 1 pass)
export OPENAI_API_KEY=...from-hermes...
/home/everlier/.local/bin/uv tool uvx --from harbor harbor run --dataset terminal-bench@2.0 --agent-import-path mi_harbor.mi_agent:MiAgent --model openai/deepseek/deepseek-v4-flash --n-concurrent 1 --n-tasks 4 --yes --include-task-name fix-git --include-task-name db-wal-recovery --include-task-name path-tracing --include-task-name polyglot-c-py --jobs-dir /tmp/mi-30-eval-iter2/mi
