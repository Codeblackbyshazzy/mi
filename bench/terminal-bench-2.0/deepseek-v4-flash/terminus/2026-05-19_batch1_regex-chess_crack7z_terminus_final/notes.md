# NOTES - 2026-05-19 batch1 2-task (regex-chess, crack-7z-hash) - TERMINUS-2 FINAL (real score)

**Context**: First batch of the 30-task Terminal-Bench 2.0 eval comparing mi (adapter) vs terminus-2 (reference harness) on deepseek-v4-flash via OpenRouter. Launched ~01:30 CEST in timebox until 6am. This snapshot captures the FINAL state for the terminus-2 side after full completion.

**Results captured at ~01:48 (post completion)**:
- 2/2 trials completed, finished=True
- 1 verified pass (reward.txt=1): crack-7z-hash
- 1 fail (reward=0): regex-chess
- Mean reward: 0.5
- From result.json: n_errors=0, cost n/a, high token use (cache hits on model context)

**Per-harness observations (from monitor/agg cycles + logs/trajectories)**:
- terminus-2: Used n-concurrent=2, ran both tasks in parallel from start. On crack-7z-hash: classic workflow - installed p7zip/john, used 7z2john to extract hash, ran john incremental cracker for many episodes. Succeeded in cracking within time. Also active on regex-chess (hard algo task: LLM must generate regex chess move validator). Despite litellm parser warnings and "model not mapped", it produced valid trajectories and 50% pass. Total runtime 14m32s.
- mi side (for comparison, still running at snapshot time): n=1, slower ramp up, only regex-chess materialized (crack pending at time of early polls), 0 completed, no rewards yet. mi tends to be more conservative on setup/episodes for complex tasks.

**mi vs terminus diffs for completed tasks**:
- crack-7z-hash: terminus passed (successful hash crack via john), mi not yet completed at time of this snapshot (later batches show mi can pass fix-git etc but slower on crypto/ long jobs).
- regex-chess: both struggled (terminus 0, mi pending); this task requires implementing a full chess logic via regex patterns (very hard for LLM agents without search or code exec tricks).
- Overall: terminus faster throughput due to higher concurrency and more aggressive episode execution. mi produces cleaner/diagnostic outputs but lags in wall time and episode count on hard tasks.
- Early signal: matches 10-task baseline where mi passed fix-git (SWE) but here terminus succeeded on a crypto cracking task where mi may or not later.

**Issues observed**:
- Repeated LiteLLM warnings for deepseek-v4-flash (bedrock/sagemaker pre-load, price map fallback) - non-fatal for both.
- Docker container management: containers cleaned after finish (docker count dropped 17->16 after this batch).
- Task intrinsics: crack-7z is time-variable (john may take variable time), regex-chess is compute/alg heavy.

**Artifacts**:
- Full job ts dir copied: includes agent/ (for mi would be mi-output), for terminus: full trajectories, episodes, trial.log, verifier/ with reward.txt + ctrf.json + test-stdout.
- See /tmp/mi-30-eval-iter1/terminus/2026-05-19__01-30-36 for live at time (but finished).
- This + the mi batch2 snapshot provide the first "real" verified scores beyond the May18 10-task baseline.

**Next in timebox**: Continue monitor/agg cycles; snapshot mi batch2 (3/4 done, 1 pass on fix-git) similarly; update living current-results-summary.md + README with 1/2 for this; watch for more completions in iter2 mi (polyglot pending), batch3; consider small batch5 only if docker <~12-14 and ~2-3h left. Aim for final report by 5:30am.

Captured during collection iteration of the timeboxed 30-task goal (progress file iter ~5).
