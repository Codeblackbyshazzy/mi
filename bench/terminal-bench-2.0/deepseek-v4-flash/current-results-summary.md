# Terminal-Bench 2.0 (deepseek-v4-flash) — mi vs terminus-2 Current Results Summary
**Generated:** 2026-05-19 ~01:44 CEST (during timeboxed 30-task eval until 6am)  
**Source:** `./mi_harbor/monitor-30task-evals.sh --tail 15` + `./mi_harbor/aggregate-tb-results.sh` (post batch4)  
**Repo:** /home/everlier/code/mi  
**Progress file:** /tmp/timeboxed-mi-vs-harness-evals-tbench-30-tasks-1779146755.md (batches 1-4 tracked)

## Aggregator Table (latest run)
```
=== Terminal-Bench 2.0 (deepseek-v4-flash) mi vs terminus-2 Aggregation ===
Generated: 2026-05-19 01:43:38 CEST

Per-run summary:
Harness      Run                                        Done       Pass      Pct      MeanR     Duration   Status
-------      -------------------------------------- -------- ---------- -------- ---------- ------------ --------
mi           2026-05-17_1task_initial                      ?          ?        ?          ?        15:13 snapshot
mi           2026-05-18_10task_estimator                2/10 2 / 10  (20      20%        0.2 ~71 minutes (4262s)    final
mi           2026-05-19_2task_regex-chess_crack7z_       0/2          ?        ?          ?        01:34 partial/live
terminus     2026-05-18_10task_reference                0/10          ?        ?          ?        23:03 partial/live
terminus     2026-05-19_2task_regex-chess_crack7z_       0/2          ?        ?          ?        01:34 partial/live

=== Grand totals (from parsed scores / raw rewards across all committed snapshots) ===
mi     : 0 passes / 2 completed / 12 tasks  (0.0% pass rate on completed)
terminus: 0 passes / 0 completed / 12 tasks  (0.0% pass rate on completed)

=== Live running batches (from /tmp result.json, if present) ===
/tmp/mi-30-eval-iter1/mi/2026-05-19__01-30-34/result.json
  n_completed: 0/2  running=1  finished=False
/tmp/mi-30-eval-iter2/mi/2026-05-19__01-34-18/result.json
  n_completed: 2/4  running=1  finished=False
  live verified passes (reward=1): 1/3 (from 3 reward files)
/tmp/mi-30-eval-iter3/mi/2026-05-19__01-39-00/result.json
  n_completed: 0/5  running=1  finished=False
/tmp/mi-30-eval-iter4/mi/2026-05-19__01-42-45/result.json
  n_completed: 0/3  running=1  finished=False
/tmp/mi-30-eval-iter1/terminus/2026-05-19__01-30-36/result.json
  n_completed: 1/2  running=1  finished=False
  live verified passes (reward=1): 0/1 (from 1 reward files)
/tmp/mi-30-eval-iter2/terminus/2026-05-19__01-34-28/result.json
  n_completed: 0/4  running=2  finished=False
/tmp/mi-30-eval-iter3/terminus/2026-05-19__01-39-07/result.json
  n_completed: 1/5  running=2  finished=False
  live verified passes (reward=1): 1/1 (from 1 reward files)
/tmp/mi-30-eval-iter4/terminus/2026-05-19__01-42-55/result.json
  n_completed: 0/3  running=2  finished=False
```

## All 30 Tasks — Current Status (as of iter 4 launch)
**Total launched:** 14 tasks across 4 batches (2+4+5+3)  
**mi concurrency:** n-concurrent=1 (diagnostic)  
**terminus-2 concurrency:** n-concurrent=2 (faster wall time)

### Running (14 tasks)
**Batch 1 / iter1** (regex-chess, crack-7z-hash) — launched ~01:30  
- mi: 0/2 completed, 1 running  
- terminus: 1/2 completed, 1 running (0 verified passes in live rewards)  
- PIDs: 1089838 (mi), 1090236 (terminus)  
- Docker examples: regex-chess__*, crack-7z-hash__* (12+ min elapsed)

**Batch 2 / iter2** (fix-git, db-wal-recovery, path-tracing, polyglot-c-py) — launched ~01:34  
- mi: **2/4 completed**, 1 running; **1 live verified pass** (reward.txt=1 among 3 reward files)  
- terminus: 0/4 completed, 2 running  
- PIDs: 1165089 (mi), 1168602 (terminus)  
- Note: fix-git was one of the 2 passes in prior 10-task mi baseline

**Batch 3 / iter3** (largest-eigenval, mcmc-sampling-stan, hf-model-inference, qemu-startup, configure-git-webserver) — launched ~01:38  
- mi: 0/5 completed, 1 running  
- terminus: 1/5 completed, 2 running; **1 live verified pass** (reward=1)  
- PIDs: 1269524 (mi), 1272212 (terminus)  
- Docker: largest-eigenval (2x), hf-model, etc.

**Batch 4 / iter4** (chess-best-move, openssl-selfsigned-cert, train-fasttext) — launched ~01:42 (this iteration)  
- mi: 0/3 completed, 1 running (PID 1382249)  
- terminus: 0/3 completed, 2 running (PID 1386919)  
- Just starting (containers: train-fasttext__*, chess-best-move__* (2x) appearing)  
- Diversity: games/chess, crypto, ML training

**Current load (post-batch4):** 18 total docker containers; ~12-13 active T-Bench task envs (improved monitor now catches all __*-main-1 including dna-assembly, chess, train-fasttext etc.); ~6 harbor python runners + parents.

### Pending (16 tasks — not yet launched in 30-task runs)
- count-dataset-tokens, caffe-cifar-10, fix-code-vulnerability, sanitize-git-repo, adaptive-rejection-sampler, dna-assembly, torch-tensor-parallelism, gpt2-codegolf, llm-inference-batching-scheduler, break-filter-js-from-html, reshard-c4-data, write-compressor, merge-diff-arc-agi-task, winning-avg-corewars, log-summary-date-ranges, pytorch-model-cli

(These were the high-priority suggestions in the task: chess-best-move, openssl-*, winning-avg-*, log-summary-*, count-*, train-fasttext, caffe-*, sanitize-*, torch-*, gpt2-codegolf etc. — batch4 took 3 of the top; more SWE/ML/crypto/games in queue.)

## Known Passes
- **From 10-task baseline (2026-05-18_10task_estimator, mi):** 2/10 passes (20%, mean reward 0.2). Specifically: `fix-git` and `fix-code-vulnerability` (per prior run notes).
- **Live in current 30-task batches (from enhanced aggregator reward.txt scan):** 
  - mi batch2 (iter2): **+1 verified pass** (among the 2 completed trials on fix-git/db-wal/path-tracing/polyglot-c-py).
  - terminus batch3 (iter3): **+1 verified pass**.
- Grand snapshot totals currently reflect only committed bench dirs (still 2 passes on mi side from 10-task); live signals indicate mi is surfacing passes in the new runs.
- No full per-task pass lists yet (await snapshots of completed job dirs into bench/... for score.txt with explicit lists + trajectories).

## Notes on mi vs terminus-2 Differences Observed So Far
- **Concurrency & speed:** mi uses --n-concurrent 1 (stable diagnostics, slower wall time on batches); terminus-2 uses 2 (or more) → faster episode throughput and more parallel containers (visible in etime and docker counts).
- **Progress patterns:** terminus often shows more episodes early (e.g. crack-7z john runs, multiple on batch3); mi slower to first episodes but produces clean trajectories. iter2 mi reached 2/4 completed while terminus at 0/4.
- **Reliability / parsing:** Both hit LiteLLM/Bedrock warnings (non-fatal); some docker env setup restarts observed early. mi adapter (mi_harbor.mi_agent) normalizes base URLs for OpenRouter.
- **Pass signals:** Early live rewards favor mi slightly in batch2 (1 pass); terminus has 1 in batch3. Hard tasks (regex-chess, crack-7z, largest-eigenval, path-tracing) taking 10-30+ min real time + long sim.
- **Infra:** Both land full job dirs under /tmp/mi-30-eval-iterN/{mi,terminus}/<ts>/ with agent/ verifier/ logs + result.json. Snapshots copied only for batch1 so far.
- **Load:** Post 4 batches ~12-13 task containers; host handling (18 total dockers). Safe for now; further batches will require monitoring docker ps + killing if >20-25.

## By 6am Projection (deadline 2026-05-19 06:00 CEST, ~4h 15m remaining from 01:45)
- **Coverage:** 14/30 launched. With ~2-4h per batch of 3-5 (mi n=1 bottleneck), expect 1-2 more batches (e.g. 4-5 tasks: sanitize-git-repo + gpt2-codegolf + winning-avg-corewars + count-dataset-tokens or dna-assembly + torch-*) before 6am → total ~19-23/30 covered.
- **Scores:** As older batches (esp. iter1/2) complete, snapshot their /tmp job dirs to new bench/.../2026-05-19_*_batchN_{mi,terminus}/ with real score.txt (pass lists, meanR, duration) + notes.md. Re-run aggregator frequently for updated grand totals + pass@1.
- **Outcome potential:** mi may reach 4-6 passes total (baseline 2 + 1-2 new from batch2 + more from remaining SWE/ML); terminus as strong reference may match or exceed on some (full trajectories help debugging). Key diffs will be in failure modes on crypto (openssl, crack-7z), ML (train-fasttext, torch), games (chess, corewars), and systems (qemu, db-wal).
- **High-impact remaining this run:** 
  1. Frequent monitor+agg cycles (every 15-30min).
  2. On first reward/complete signals in iter1/2/3: immediately snapshot + write accurate score.txt.
  3. Optional batch5 (3-4 pending) if docker <~16-18 and time allows (~03:00-04:00 window).
  4. Final 6am report: committed bench/.../final-30task-report.md or update this summary + README with complete pass tables, mi vs terminus diff summary, timing stats, and recommendations.
- **Risks:** Some tasks (regex-chess, path-tracing, largest-eigenval) may hit timeouts or require >1h; docker pressure if not managed; OpenRouter rate limits on deepseek-v4-flash.
- **Exit strategy:** At ~05:30 stop new launches, let running finish or SIGTERM cleanly, collect all snapshots + agg output, commit final summary + any new bench dirs. Preserve 30-LOC core (no changes to index.mjs/tools).

## Artifacts & Tooling (this iteration)
- **New/updated committed:** `current-results-summary.md` (this file), monitor-30task-evals.sh (docker robustness), aggregate-tb-results.sh (live pass parsing), bench/.../README.md (batch4 status), mi_harbor/README.md, mi_harbor/presets/...-tb2-30.sh (iter4 notes).
- **Launch:** /tmp/launch-batch4.sh (exact established pattern; PIDs 1382249 mi + 1386919 terminus recorded; log /tmp/mi-30-eval-iter4-*-launch.log).
- **Next commands:** `watch -n 300 './mi_harbor/monitor-30task-evals.sh --tail 10 && ./mi_harbor/aggregate-tb-results.sh >> /tmp/agg-history.log'`
- All per CLAUDE.md (no core edits, facts not required for pure eval, lines preserved).

**Status:** 14 tasks live + partial scores emerging. Pushing coverage + visibility. Ready for continued monitoring until 6am.

---
*End of current-results-summary.md (regenerated/updated each iteration with fresh monitor+agg output)*
---

## Collection Updates — This Iteration (real verified scores captured, ~01:50 CEST 2026, after 3 poll cycles)

**New real bench/ artifacts produced (first from the 30-task run, beyond May 18 10-task baseline):**

1. **terminus batch1 final snapshot**:
   - Path: `bench/terminal-bench-2.0/deepseek-v4-flash/terminus/2026-05-19_batch1_regex-chess_crack7z_terminus_final/`
   - Real score: **Pass rate: 1 / 2 (50%)**, Mean reward: 0.5
   - Passed: `crack-7z-hash` (reward.txt=1)
   - Failed: `regex-chess` (0)
   - Full ts dir + command.sh + launch log + detailed notes.md with per-harness obs + mi vs term diffs copied from /tmp/mi-30-eval-iter1/terminus/2026-05-19__01-30-36 (finished 2/2 at 01:45)
   - Duration ~15min

2. **mi batch2 partial high-progress snapshot** (focus on older batch2 where mi 3/4 +1pass):
   - Path: `bench/terminal-bench-2.0/deepseek-v4-flash/mi/2026-05-19_batch2_4task_fixgit_dbwal_path_polyglot_mi_partial/`
   - Real (provisional) score: **Pass rate: 1 / 3 (33% on completed; 4th pending)**, Mean reward: 0.333
   - Passed: `fix-git` (consistent with 10-task baseline)
   - Failed (completed): `db-wal-recovery`, `path-tracing` (0 reward; noted agent exit errs in stats)
   - Pending: `polyglot-c-py`
   - Full ts dir copied from /tmp/mi-30-eval-iter2/mi/2026-05-19__01-34-18 , + command.sh, launch logs, notes.md (mi vs term diffs: mi 3/4 vs term 0/4 at capture time; term later showed progress in cycle3)
   - Snapshot time ~01:48 after cycles

**Updated live signals (cycle 3 post-sleep 90s)**:
- mi iter2 (batch2): still ~3/4 , 1 pass
- term iter2 (batch2): progressed to 2/4 completed, 1/2 rewards → **+1 verified pass** for term on batch2
- mi iter3: 1/5 completed, 1 pass
- term iter3: 2/5 , 1 pass (of 2 rewards)
- term batch1: confirmed 2/2 1pass
- Docker: continued drop (16->? during cycles; one container per finished task cleaned)
- Monitor now detects the new snapshot dirs we created (total run dirs 47)

**Updated grand totals (incorporating new real snapshots + live rewards, beyond prior 2/10 mi baseline)**:
- mi passes so far: 2 (10-task) + 1 (batch2 fix-git) = **at least 3**; plus live signals in batch3
- terminus passes: 1 (batch1 crack-7z-hash) + 1 (batch2) + 1 (batch3 configure-git) = **at least 3**
- More will accrue as pending finish (polyglot, remaining in 3/4, batch4 just ramping)

**Actually completed tasks with pass/fail (from snapshots + verified rewards)**:
- Batch1 (regex-chess, crack-7z-hash):
  - terminus: crack-7z-hash=pass, regex-chess=fail (1/2)
  - mi: still pending (0/2 at early polls)
- Batch2 (fix-git, db-wal-recovery, path-tracing, polyglot-c-py):
  - mi: fix-git=pass, db-wal= fail, path-tracing=fail, polyglot=pending (1/3)
  - term: 2/4 completed with 1 pass (specific task ID from rewards not re-scanned here but in /tmp)
- Batch3: term 2/5 with 1 pass (configure-git-webserver confirmed earlier), mi 1/5 1 pass

**Docs updated**: this summary + deepseek-v4-flash/README.md (live batch status + new snapshots section) + progress file (via this run). No batch5 launched (docker ~16 not low enough post-completions; respect capacity, batch4 still active with 8+ containers).

**High-impact**: These are the first verified real scores from 30-task run in bench/. Continue collection over next ~4h (more finishes expected in batch2/3), final report ~5:30-6am. Monitor/agg will show rising n_completed.

**Cycle count in this unit**: 3 full (60s +90s sleeps + runs); focused older batches 1-2 per plan.

