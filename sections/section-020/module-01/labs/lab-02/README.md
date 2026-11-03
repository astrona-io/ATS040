---
estimated_duration: 20m
---

# Lab: Run Retried Work With A Job And A CronJob

Graded lab for the serverless and event-driven part of the module. The cluster has the `probe` HTTP server and the `shuttle` curl pod; the learner creates a Job and a CronJob. The task is in `question.md`; the walkthrough is in `solution.md`.

Status: UNTESTED. Written and statically checked only. The validation scripts and the reference solution have not been run.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS040.git -c sections/section-020/module-01/labs/lab-02
astrona submit --git ssh://git@github.com/astrona-io/ATS040.git -c sections/section-020/module-01/labs/lab-02
astrona destroy ats-040-lab-020-01-02
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-job-spec.sh` | Job process-event has backoffLimit 4, a 120 second deadline and a cleanup time |
| `validate-restart-policy.sh` | The Job pod template uses restartPolicy Never or OnFailure |
| `validate-idempotency-key.sh` | The Job command sends the header Idempotency-Key: evt-1001 |
| `validate-job-complete.sh` | The Job completed once |
| `validate-cronjob.sh` | CronJob nightly-report has the schedule, Forbid policy, deadline, history limits and is suspended |

The checks run right after the Job completes. The Job has `ttlSecondsAfterFinished: 600`, so grade within ten minutes.
