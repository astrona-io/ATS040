---
estimated_duration: 20m
---

# Lab: Fix A Defect Through A Focused Change

Graded lab for the community and collaboration module. The learner reports a defect, makes one focused change and records the reason. The task is in `question.md`; the walkthrough is in `solution.md`.

Status: UNTESTED. Written and statically checked only. The validation scripts and the reference solution have not been run.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS040.git -c sections/section-030/module-01/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS040.git -c sections/section-030/module-01/labs/lab-01
astrona destroy ats-040-lab-030-01
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-issue.sh` | ConfigMap issue-report names the component and the expected path /readyz |
| `validate-readiness.sh` | The scout readiness probe calls /readyz |
| `validate-focused-change.sh` | The scout liveness probe still calls /healthz and the container keeps its name, image and port |
| `validate-change-cause.sh` | The Deployment records the reason in the annotation kubernetes.io/change-cause |
| `validate-rollout.sh` | The rollout finished and scout has one ready replica |
