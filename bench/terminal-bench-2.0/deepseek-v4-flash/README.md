# DeepSeek-V4-Flash — Terminal-Bench 2.0

Model: deepseek/deepseek-v4-flash (OpenRouter)
Benchmark: terminal-bench@2.0 (89 tasks)

## Structure

- `mi/`        — runs using this repo's mi agent (via mi_harbor adapter)
- `terminus/`  — runs using Harbor's Terminus agent (strong reference harness for comparison)

## Run naming

`YYYY-MM-DD_Ntasks_<notes>/`

Inside each run dir put:
- `command.sh`   (exact command)
- `score.txt`    (pass rate + raw numbers)
- `notes.md`     (key observations, cost, duration, failure modes)
- `job/`         (copy or symlink to the Harbor job output dir)

## Current 10-task estimator preset

See `mi_harbor/presets/openrouter-deepseek-v4-flash-tb2-10.sh`

Tasks (stratified for best extrapolation):
count-dataset-tokens, train-fasttext, caffe-cifar-10, fix-code-vulnerability,
sanitize-git-repo, adaptive-rejection-sampler, dna-assembly, fix-git,
torch-tensor-parallelism, gpt2-codegolf

## 30-task side-by-side eval (mi vs. another harness)

See `mi_harbor/presets/openrouter-deepseek-v4-flash-tb2-30.sh`

This preset runs the 30-task set with the mi adapter (n-concurrent=1 for diagnostics).
It is the concrete artifact for advancing the timeboxed 30-task Terminal-Bench goal.

**Selection criteria** (documented in preset header):
- Start with the validated 10-task stratified set (best 10 for extrapolation).
- Add 20 more tasks drawn from prior jobs/bench runs + new ones.
- Stratify across categories for diversity: ML/data (llm-inference-*, pytorch-*, hf-*, train-*, reshard-*, count-*), SWE/git (fix-*, sanitize-*, merge-*, configure-git-*, gpt2-codegolf), security/crypto (fix-code-vuln, crack-7z, openssl-*, vulnerable-*), scientific (mcmc-*, path-tracing, raman if avail), systems (qemu-*, db-wal-*, largest-eigenval), games/algos (regex-chess, chess-best-move, winning-avg-corewars), polyglot, etc.
- Ensures coverage beyond the original 10 while keeping run feasible.

**30 tasks list**:
count-dataset-tokens train-fasttext caffe-cifar-10 fix-code-vulnerability sanitize-git-repo adaptive-rejection-sampler dna-assembly fix-git torch-tensor-parallelism gpt2-codegolf llm-inference-batching-scheduler break-filter-js-from-html reshard-c4-data write-compressor merge-diff-arc-agi-task winning-avg-corewars log-summary-date-ranges pytorch-model-cli largest-eigenval regex-chess crack-7z-hash db-wal-recovery path-tracing polyglot-c-py mcmc-sampling-stan hf-model-inference qemu-startup configure-git-webserver chess-best-move openssl-selfsigned-cert

**Live batch status (timeboxed 30-task eval, collection phase ~01:50 CEST 2026, after 3 monitor/agg cycles)**:
- Batch 1 (2 tasks): regex-chess, crack-7z-hash — launched iter1 (PIDs 1089838 mi still running 0/2 / 1090236 terminus finished); **real final for terminus: 2/2 completed, Pass rate 1/2 (50%) — crack-7z-hash=pass, regex-chess=fail** (meanR 0.5); new dedicated snapshot `2026-05-19_batch1_regex-chess_crack7z_terminus_final/` with full ts dir, score.txt, notes (first real 30-task artifact); provisional snapshot in `2026-05-19_2task_regex-chess_crack7z_iter1/`
- Batch 2 (4 tasks): fix-git, db-wal-recovery, path-tracing, polyglot-c-py — launched iter2 (PIDs 1165089/1168602); **mi high progress 3/4 completed, real provisional Pass rate 1/3 (33%) on completed — fix-git=pass (consistent baseline), db-wal+path=fail, polyglot pending** (meanR 0.333); new snapshot `2026-05-19_batch2_4task_fixgit_dbwal_path_polyglot_mi_partial/` with copied job dir + accurate score/notes; term progressed to 2/4 +1 pass in later cycles
- Batch 3 (5 tasks): largest-eigenval, mcmc-sampling-stan, hf-model-inference, qemu-startup, configure-git-webserver — launched iter3; mi 1/5 +1 verified pass, term 2/5 +1 pass (e.g. configure-git-webserver confirmed reward=1); live /tmp/mi-30-eval-iter3-*
- Batch 4 (3 tasks): chess-best-move, openssl-selfsigned-cert, train-fasttext — launched iter4 (PIDs 1382249 mi / 1386919 terminus); 0/3 just ramping (containers active); /tmp/mi-30-eval-iter4-*
- **New real snapshots this collection iter (first verified from 30-task run)**: see above batch1-terminus-final (1/2) + batch2-mi-partial (1/3); monitor/agg now list 47 run dirs total; 3 poll cycles (60-90s sleeps) performed focusing batches 1-2
- Monitor/agg tools robust (detect new snapshots, live rewards from reward.txt=1, docker __*-main-1); use them for rolling + table (now shows mi + term at least ~3 passes each incl. baseline + new)
- Remaining ~16 tasks pending — watch for more completions before 6am (no batch5 launched, docker ~16 not sufficiently low post cleanups)
- 10-task estimator results (prior): mi 2/10 pass in `2026-05-18_10task_estimator/`
- See `current-results-summary.md` (updated with new real scores, pass lists, grand totals ~3+ each side, completed task breakdown) for full status + projection.

**Another harness defined**: `terminus` / `terminus-2`
- The official/reference Terminal-Bench harness/agent bundled with Harbor.
- Provides strong baseline (full ATIF trajectories, episode recordings, higher reliability on hard tasks).
- Used for all prior "terminus/" results in this bench/ tree.
- Side-by-side protocol: run identical `harbor run --dataset terminal-bench@2.0 --model openai/deepseek/deepseek-v4-flash` once with `--agent-import-path mi_harbor.mi_agent:MiAgent` (mi) and once with `--agent terminus-2` (reference), same --include-task-name filters and --n-tasks.
- Results land in separate job dirs under mi/ vs. terminus/ for diffing pass@1, cost, latency, failure modes.

Run example for terminus on the 30 (or subset):
  ./mi_harbor/presets/openrouter-deepseek-v4-flash-tb2-30.sh --agent terminus-2 --agent-import-path '' --n-concurrent 4

Keep all logs/job dirs under bench/... for comparison.

## Other harness

Using `terminus` (or `terminus-2`) via:
harbor run --agent terminus ... --model openai/deepseek/deepseek-v4-flash

Keep logs here for direct apples-to-apples comparison with the mi numbers.