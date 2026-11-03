---
estimated_duration: 20m
---

# Lab: Migrate Removed API Versions

Graded lab for the API maturity module. Three manifests in a ConfigMap use API versions that the cluster no longer serves. The learner migrates and applies them. The task is in `question.md`; the walkthrough is in `solution.md`.

Status: UNTESTED. Written and statically checked only. The validation scripts and the reference solution have not been run.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS040.git -c sections/section-030/module-02/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS040.git -c sections/section-030/module-02/labs/lab-01
astrona destroy ats-040-lab-030-02
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-cronjob.sh` | CronJob report-sweep exists and is served as batch/v1 with the original schedule and policy |
| `validate-hpa.sh` | HPA scout exists and is served as autoscaling/v2 with 1 to 3 replicas and 70 percent CPU |
| `validate-pdb.sh` | PodDisruptionBudget scout-pdb exists and is served as policy/v1 with minAvailable 1 and the scout selector |
| `validate-notes.sh` | ConfigMap migration-notes records the current apiVersion of each kind |
| `validate-untouched.sh` | The legacy-manifests ConfigMap is unchanged and scout is not modified |
