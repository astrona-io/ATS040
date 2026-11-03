---
estimated_duration: 20m
---

# Lab: Budget A Namespace And Right-Size A Workload

Graded lab for the cloud cost module. The scout Deployment requests far more than it uses and the namespace has no labels, quota or defaults. The learner labels the namespace, adds a ResourceQuota and a LimitRange and right-sizes scout. The task is in `question.md`; the walkthrough is in `solution.md`.

Status: UNTESTED. Written and statically checked only. The validation scripts and the reference solution have not been run.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS040.git -c sections/section-010/module-04/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS040.git -c sections/section-010/module-04/labs/lab-01
astrona destroy ats-040-lab-010-04
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-labels.sh` | Namespace starfleet has labels team=bridge and cost-center=exploration |
| `validate-quota.sh` | ResourceQuota compute-budget allows 2 CPU and 2Gi memory of requests, 4Gi of memory limits and 10 pods |
| `validate-limitrange.sh` | LimitRange container-defaults sets a default request of 50m CPU and 64Mi memory and a default memory limit of 128Mi |
| `validate-rightsized.sh` | Container scout requests 100m CPU and 64Mi memory and has a memory limit of 128Mi |
| `validate-available.sh` | Deployment scout is available with its new pod |
