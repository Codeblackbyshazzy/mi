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

**Live batch status (timeboxed 30-task eval, iter 4 as of ~01:43 CEST 2026)**:
- Batch 1 (2 tasks): regex-chess, crack-7z-hash — launched iter1 (PIDs 1089838 mi / 1090236 terminus); mi 0/2, term 1/2 completed; snapshot in `2026-05-19_2task_regex-chess_crack7z_iter1/`
- Batch 2 (4 tasks): fix-git, db-wal-recovery, path-tracing, polyglot-c-py — launched iter2 (PIDs 1165089/1168602); mi 2/4 completed (1+ live verified pass from rewards), term 0/4; still running
- Batch 3 (5 tasks): largest-eigenval, mcmc-sampling-stan, hf-model-inference, qemu-startup, configure-git-webserver — launched iter3 (PIDs 1269524 mi / 1272212 terminus); mi 0/5, term 1/5 (1 live verified pass); new /tmp/mi-30-eval-iter3-*
- Batch 4 (3 tasks): chess-best-move, openssl-selfsigned-cert, train-fasttext — launched iter4 (PIDs 1382249 mi / 1386919 terminus, n-conc 1/2); 0/3; just starting, new /tmp/mi-30-eval-iter4-*
- Monitor improved (broader docker task detection for any __*-main-1, total count); aggregator enhanced (live verified pass counts from reward.txt in /tmp jobs).
- Use `mi_harbor/monitor-30task-evals.sh --tail 20` + `mi_harbor/aggregate-tb-results.sh` for rolling status + table (now shows early passes: mi +1 in batch2 live).
- Remaining ~16 tasks pending (e.g. count-dataset-tokens, caffe-cifar-10, fix-code-vulnerability, sanitize-git-repo, gpt2-codegolf, winning-avg-corewars, log-summary-date-ranges, dna-assembly, torch-tensor-parallelism etc.) — more batches before 6am.
- 10-task estimator results (prior): mi 2/10 pass in `2026-05-18_10task_estimator/`
- See `current-results-summary.md` (committed artifact) for latest aggregator table + full 30-task status + 6am projection.

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