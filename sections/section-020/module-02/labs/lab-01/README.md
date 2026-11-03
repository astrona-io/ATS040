---
estimated_duration: 20m
---

# Lab: Extend Kubernetes With A Custom Resource

Graded lab for the cloud native ecosystem module. The learner records a platform-job map and adds a new API kind with a schema. The task is in `question.md`; the walkthrough is in `solution.md`.

Status: UNTESTED. Written and statically checked only. The validation scripts and the reference solution have not been run.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS040.git -c sections/section-020/module-02/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS040.git -c sections/section-020/module-02/labs/lab-01
astrona destroy ats-040-lab-020-02
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-notes.sh` | ConfigMap ecosystem-notes maps four platform jobs to their categories |
| `validate-crd.sh` | CRD sensors.fleet.example.com is namespaced, served and stored as v1 with kind Sensor |
| `validate-schema.sh` | The schema requires target and limits intervalSeconds to an integer of at least 1 with default 30 |
| `validate-sensor.sh` | Sensor scout-sensor exists with target scout and the defaulted interval 30 |
| `validate-rejects.sh` | The API server rejects a Sensor with intervalSeconds 0 and one without target |
