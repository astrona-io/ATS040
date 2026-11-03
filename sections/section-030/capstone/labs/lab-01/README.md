---
estimated_duration: 30m
---

# Lab: Community And API Capstone

Integration capstone for the community and APIs section. The learner makes a focused change with a recorded cause, migrates a removed API version and documents the change for the project. The task is in `question.md`; the walkthrough is in `solution.md`.

Status: UNTESTED. Written and statically checked only. The validation scripts and the reference solution have not been run.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS040.git -c sections/section-030/capstone/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS040.git -c sections/section-030/capstone/labs/lab-01
astrona destroy ats-040-capstone-030
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-probe-path.sh` | The readiness probe of beacon uses /readyz |
| `validate-rollout-ready.sh` | Deployment beacon has 2 available replicas on the new revision |
| `validate-change-cause.sh` | The Deployment records why it changed in the change-cause annotation and has revision 2 or higher |
| `validate-cronjob-v1.sh` | CronJob beacon-sweep exists through batch/v1 with the schedule and policy of the legacy manifest |
| `validate-change-record.sh` | ConfigMap change-record states the replaced version, its replacement and the beta support window |
| `validate-issue-report.sh` | ConfigMap issue-report names the bug and the special interest group that owns CronJob |
