---
estimated_duration: 20m
---

# Lab: Create A Job And A CronJob With Limits

Graded lab for the serverless module. The learner creates a Job with a retry limit, a deadline and automatic cleanup, and a CronJob with a schedule and a concurrency policy. The task is in `question.md`; the walkthrough is in `solution.md`.

Status: UNTESTED. Written and statically checked only. The validation scripts and the reference solution have not been run.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS040.git -c sections/section-020/module-05/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS040.git -c sections/section-020/module-05/labs/lab-01
astrona destroy ats-040-lab-020-05
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-job-spec.sh` | Job beacon sets backoffLimit 2, activeDeadlineSeconds 120, ttl 3600 and restartPolicy Never |
| `validate-job-complete.sh` | Job beacon is complete |
| `validate-cron-schedule.sh` | CronJob patrol runs every five minutes with concurrencyPolicy Forbid |
| `validate-cron-history.sh` | CronJob patrol keeps one successful and one failed Job |
| `validate-cron-template.sh` | Jobs of patrol stop after 60 seconds and do not restart in place |
