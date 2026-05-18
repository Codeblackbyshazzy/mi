# NOTES - 2026-05-19 batch2 4-task (fix-git, db-wal-recovery, path-tracing, polyglot-c-py) - MI PARTIAL (3/4, 1 pass) 

**Context**: Batch 2 from the 30-task T-Bench eval (mi vs terminus-2 side-by-side on deepseek-v4-flash). Launched ~01:34 CEST using the 30-task preset. This snapshot taken during collection phase (~01:48, after 2 poll cycles) capturing substantial progress on the mi side (older batch focus).

**Live status at snapshot (from result.json + reward scan + monitor/agg)**:
- mi: 3/4 completed, 1 running (polyglot-c-py); 1 verified pass (reward=1 on fix-git); meanR=0.333 on the 3; noted 3 errored trials in stats (NonZeroAgentExitCodeError on the completed ones, but rewards distinguish pass/fail).
- terminus-2 (same tasks): 0/4 completed, 2 running; 0 reward files yet (slower start on this batch vs mi).

**Per-harness + diffs**:
- mi (n-conc=1): Reached 3/4 completions faster than terminus on these tasks. Passed fix-git (consistent with the known pass in May18 10-task baseline mi 2/10, where fix-git was one). The 2 fails (db-wal-recovery, path-tracing) had agent non-zero exits but produced reward.txt=0 (verifier ran). Pending polyglot-c-py (polyglot C+py task). mi's conservative single concurrency leads to serial-ish progress but good signal on SWE task fix-git.
- terminus (n-conc=2): Still 0/4 at this time, despite parallel; perhaps more time on env setup or episodes for these particular tasks (db-wal, path-tracing are systems/sci heavy). Later iters showed term catching up on other batches (e.g. 1 pass on configure-git-webserver in batch3).
- Key diff: On batch2, mi demonstrated higher n_completed early (3 vs 0) and the pass on fix-git; terminus may excel on other categories. This provides concrete apples-to-apples data point moving beyond 10-task.

**Specific task notes**:
- fix-git: pass for mi (and known from baseline); typical git patch/repair task.
- db-wal-recovery, path-tracing: failed for mi (0 reward, errored); these involve DB recovery, ray/path sim - long horizon or specific output verification.
- polyglot-c-py: still running for mi at snapshot; interesting cross-lang task.

**Issues / surprises**:
- Agent exit errors even on reward-producing trials (infra note for mi adapter? verifier still gave 0/1).
- Docker load: 17->16 during this (batch1 term finished, cleaned).
- Litellm warnings persist across runs.
- Early verified passes now: mi +1 (batch2 fix-git, plus baseline 2), term +1 (batch1 crack-7z) +1 (batch3).

**Artifacts in this snapshot**:
- Full copied job ts dir with per-task agent/ (mi-output.txt, diagnostics, timing), verifier/reward.txt, trial.log, result.json, config.
- launch logs + batch2.sh included for reproducibility.
- Complements the terminus batch1 final snapshot (1/2 pass on crack-7z).

**Next**: More poll cycles (expect polyglot finish or more in batch3); update current-results-summary.md with these real numbers (mi 1/3 batch2 + term 1/2 batch1 + known 10task 2/10); possibly batch5 of 2 (e.g. winning-avg-corewars + gpt2-codegolf) only if docker drops significantly <14 and time; final collection + report before 6am. No core mi changes.

This iteration produces the first real verified 30-task-run artifacts in bench/ .
