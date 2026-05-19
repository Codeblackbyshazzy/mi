# Batch 5 (winning-avg-corewars + gpt2-codegolf) mi final snapshot notes
- Snapshot created: 2026-05-19 ~02:42 CEST in light status checkpoint unit (post iter9 02:42 polish)
- Reason: monitor run at checkpoint showed new finish for mi batch5 (iter5/mi now 2/2 completed, finished=True 02:23:43); previously described in iter9 as 1 running (winning); reward=0 for both tasks; no reward=1 but "or finish" triggered late snapshot.
- Launch: via /tmp/launch-batch5.sh (02:55? 01:55) , PIDs: parent 1673223 (now DEAD), mi PID captured; n-conc=1 ; jobs-dir /tmp/mi-30-eval-iter5/mi
- Tasks: winning-avg-corewars (games/algos), gpt2-codegolf (polyglot fun) — last 2 of 16 covered, no batch6 per freeze decision.
- Results:
  - gpt2-codegolf__9eTgEf5 : reward.txt=0 , NonZeroAgentExitCodeError (from prior cycles)
  - winning-avg-corewars__F4iPKf6 : reward.txt=0 , has exception.txt + result.json; finished in batch result at 02:23
- Docker at creation: 3 active T-Bench (2x train-fasttext batch4: qn3sepz=mi iter4, wd4bfpw=term iter4; hs4spuw=term winning iter5 batch5)
- Other iters: batch1-3 + batch4 (trains running no reward file yet), batch5 term: gpt2 0 + winning still running (no reward.txt in its subdir)
- Monitor/agg at checkpoint: confirmed no reward=1 anywhere new; iter5/mi now fully done 0p; iter4 1/3+1run each; iter5/term 1/2+1run; grand mi8 (from 1+1+4 baseline2) / term5 (1+1+3) on 16/30 unchanged.
- Observations: long games/ML tasks (winning, train) exceed timebox for positive reward in this run; both harnesses 0 on batch5 mi; term may still finish winning post-checkpoint. mi adapter completed its batch5 cleanly (launcher exited).
- No new passes; this snapshot captures the completion of mi's last launched batch. Focus remains on quality report over more coverage.
- Files included: full 2026-05-19__01-55-03/ job (with agent/ verifier/ for both tasks), launch-batch5.sh, iter5 launch/mi logs + pids, score.txt, this notes.
- For 6am: if term winning emits reward=1 before deadline, could snapshot term batch5 partial/final too; otherwise this + prior complete the artifact set.

See progress file for full checkpoint record and iter9 pre-freeze.
