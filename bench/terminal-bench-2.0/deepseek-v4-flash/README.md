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

**Live batch status (timeboxed 30-task eval, final pre-freeze harvest + polish ~02:40 CEST 2026, after 4 spaced monitor/agg cycles + freeze)**:
- Batch 1 (2 tasks): regex-chess, crack-7z-hash — **mi final 1/2 (crack-7z pass)**; **term final 1/2 (crack-7z pass)**; snapshots `..._batch1_*_final/`
- Batch 2 (4 tasks): fix-git etc. — **mi final 1/4 (fix-git only)**; **term final 1/4 (fix-git only)**; snapshots `..._batch2_*_final/`
- Batch 3 (5 tasks): largest-eigenval etc. — **mi final 4/4 completed passes** (eigenval+configure+hf+mcmc); **term final 3/5** (configure+mcmc+qemu); snapshots `..._batch3_*_final/` (term updated iter8)
- Batch 4 (3 tasks): chess-best-move, openssl-selfsigned-cert, train-fasttext — launched iter4; mi 1/3+1 running (train), 0p; term 2/3+1 running (train), 0p; live /tmp/mi-30-eval-iter4/* (train ~55m+)
- Batch 5 (2 tasks): winning-avg-corewars + gpt2-codegolf — mi 2/2 finished 0p (gpt2 0); term 1/2+1 running (winning ~43m+), 0p; live /tmp/...iter5/*
- **Final pre-freeze (this unit, ~02:26-02:42, 4 cycles 3-5min sleeps):** 3 active docker (2x train-fasttext, 1x winning); **no new completions or reward=1** in batch4/5 during window (all verified 0 where done); no new snapshots; bench dirs 105 total; freeze on new launches now; 16/30 covered.
- **Status checkpoint at ~02:42 (light unit, right at freeze):** ran monitor+agg+full docker/job inspect (3 containers: 2x train batch4 + term winning batch5; mi winning batch5 now finished reward=0, batch iter5/mi 2/2); **no reward=1**; created late snapshot `mi/2026-05-19_batch5_2task_winning_gpt2_mi_final/` (0/2, see score/notes); README + progress updated; standings confirmed mi 8 vs term 5. 3 runners remain (trains+term winning). Report 6am-ready.
- Monitor/agg robust; live rewards via reward.txt=0 confirmed; 10-task mi 2/10.
- **Standings (verified from snapshots):** mi 8 passes vs terminus-2 5 passes. See `final-30task-mi-vs-terminus-report.md` (polished with Final pre-freeze update section, how-to-repro, 6am-ready) + current-results-summary.md for full tables, diffs, recs, status at 03:00. All set for 6am. (Batch5 mi final snapshot added in checkpoint.)

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