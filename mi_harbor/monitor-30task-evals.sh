#!/usr/bin/env bash
#
# monitor-30task-evals.sh
# Helper script to monitor live background jobs and results for the
# timeboxed 30-task mi vs. terminus-2 side-by-side on Terminal-Bench 2.0
#
# Part of the eval infrastructure (updated in iter 3).
# Supports all iterN batches launched via nohup (auto-discovers PIDs in /tmp).
# Usage:
#   ./mi_harbor/monitor-30task-evals.sh
#   ./mi_harbor/monitor-30task-evals.sh --tail 20   # more log lines
#   ./mi_harbor/monitor-30task-evals.sh --help
#
set -euo pipefail

if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
  echo "monitor-30task-evals.sh — live snapshot of 30-task mi vs terminus-2 T-Bench evals"
  echo ""
  echo "Usage:"
  echo "  $0                # default (tail 5 log lines)"
  echo "  $0 --tail 20      # tail N lines from each job log"
  echo "  $0 --help         # this message"
  echo ""
  echo "Reports: PIDs + etime + status (iter1/2/3+), live result.json (n_completed etc),"
  echo "active docker containers, bench/ snapshot dirs present."
  echo "Run periodically from repo root during the timeboxed eval until 6am."
  exit 0
fi

TAIL_LINES=5
if [[ "${1:-}" == "--tail" && -n "${2:-}" ]]; then
  TAIL_LINES="$2"
fi

echo "=== 30-task mi vs terminus-2 Eval Monitor ==="
echo "Time: $(date '+%Y-%m-%d %H:%M:%S %Z')"
echo "Repo: $(pwd)"
echo

echo "=== Background job PIDs (from /tmp, auto-discovered all iters) ==="
shopt -s nullglob
pidfiles=(/tmp/mi-30-eval-*-*.pid)
tags=()
for pf in "${pidfiles[@]}"; do
  base=$(basename "$pf" .pid)
  if [[ "$base" == *-parent ]]; then continue; fi
  tag="${base#mi-30-eval-}"
  tags+=("$tag")
done
if [[ ${#tags[@]} -eq 0 ]]; then
  echo "  (no /tmp/mi-30-eval-*.pid files found yet)"
else
  for tag in "${tags[@]}"; do
    pidfile="/tmp/mi-30-eval-${tag}.pid"
    logfile="/tmp/mi-30-eval-${tag}.log"
    if [[ -f "$pidfile" ]]; then
      pid=$(cat "$pidfile" 2>/dev/null || echo "?")
      status=$(ps -p "$pid" -o stat,etime,cmd --no-headers 2>/dev/null || echo "DEAD (exited)")
      echo "[$tag] PID=$pid  $status"
      if [[ -f "$logfile" ]]; then
        echo "  Log tail (last $TAIL_LINES):"
        tail -n "$TAIL_LINES" "$logfile" 2>/dev/null | sed 's/^/    /'
      fi
    fi
  done
fi
shopt -u nullglob
echo

echo "=== Live job result summaries (/tmp current runs) ==="
shopt -s nullglob
for res in /tmp/mi-30-eval-*/{mi,terminus}/20*/result.json; do
  if [[ -f "$res" ]]; then
    echo "$res"
    python3 -c "
import json,sys
try:
 d=json.load(open(sys.argv[1]))
 s=d.get('stats',{})
 tot=d.get('n_total_trials','?')
 c=s.get('n_completed_trials',0)
 r=s.get('n_running_trials',0)
 fin=d.get('finished_at')
 print('  trials: {}/{} completed, {} running, finished={}'.format(c,tot,r,fin is not None))
 if s.get('evals'):
  print('  evals keys:', list(s['evals'].keys())[:5])
except Exception as e: print('  parse error:',e)
" "$res" 2>/dev/null || echo "  (parse failed)"
  fi
done
echo

echo "=== Docker containers for active T-Bench tasks ==="
docker ps --format '{{.Names}}\t{{.Status}}' 2>/dev/null | grep -E 'chess|crack|7z|wal|path|polyglot|fix-git|largest|mcmc|hf-model|qemu|configure|openssl|corewars|log-summary' || echo "  (no matching active task containers or docker not listing)"
echo

echo "=== Bench artifacts present ==="
echo "mi run dirs:"
ls -d bench/terminal-bench-2.0/deepseek-v4-flash/mi/20* 2>/dev/null | sed 's/^/  /' || echo "  (none)"
echo "terminus run dirs:"
ls -d bench/terminal-bench-2.0/deepseek-v4-flash/terminus/20* 2>/dev/null | sed 's/^/  /' || echo "  (none)"
echo "Total run dirs across harnesses: $(ls bench/terminal-bench-2.0/deepseek-v4-flash/{mi,terminus}/20* 2>/dev/null | wc -l)"
echo

echo "=== Tips ==="
echo "  Tail live: tail -f /tmp/mi-30-eval-iter*-*.log"
echo "  Check specific job: ls /tmp/mi-30-eval-iter2/mi/2026-05-19__01-34-18/"
echo "  Full status: python3 -m json.tool /tmp/.../result.json | less"
echo "  To kill a stuck batch safely: kill \$(cat /tmp/mi-30-eval-xxx.pid)"
echo "  New batches (iter3+): monitor auto-discovers; use same launch pattern."
echo
echo "Monitor run complete."