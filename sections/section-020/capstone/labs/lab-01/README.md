---
estimated_duration: 30m
---

# Lab: Architecture Capstone

Integration capstone for the architecture section. The learner makes one bare workload replaceable, disruption safe and elastic. The task is in `question.md`; the walkthrough is in `solution.md`.

Status: UNTESTED. Written and statically checked only. The validation scripts and the reference solution have not been run.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS040.git -c sections/section-020/capstone/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS040.git -c sections/section-020/capstone/labs/lab-01
astrona destroy ats-040-capstone-020
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-replicas.sh` | Deployment beacon runs at least 3 ready replicas |
| `validate-probes.sh` | The container has a readiness probe on /readyz and a liveness probe on /healthz |
| `validate-requests.sh` | The container requests CPU and memory and has a memory limit |
| `validate-pdb.sh` | A policy/v1 PodDisruptionBudget keeps at least 2 beacon pods available |
| `validate-settings.sh` | beacon reads ConfigMap beacon-settings through envFrom |
| `validate-hpa.sh` | An autoscaling/v2 HorizontalPodAutoscaler scales beacon between 3 and 6 on 70 percent CPU |
