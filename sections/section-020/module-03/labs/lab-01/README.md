---
estimated_duration: 20m
---

# Lab: Make A Workload Autoscale

Graded lab for the autoscaling module. The scout Deployment has no resource requests and no HPA; the learner fixes the workload and creates a tuned HPA. The task is in `question.md`; the walkthrough is in `solution.md`.

Status: UNTESTED. Written and statically checked only. The validation scripts and the reference solution have not been run.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS040.git -c sections/section-020/module-03/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS040.git -c sections/section-020/module-03/labs/lab-01
astrona destroy ats-040-lab-020-03
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-requests.sh` | Container scout requests 100m CPU and 32Mi memory |
| `validate-hpa.sh` | HPA scout targets Deployment scout with 2 to 5 replicas and 60 percent CPU utilization |
| `validate-behavior.sh` | Scale-down window is 120 seconds and scale-up is limited to 2 pods per 30 seconds |
| `validate-active.sh` | The HPA can compute the metric (ScalingActive is True) |
| `validate-replicas.sh` | scout has at least 2 ready replicas |

The lab cluster installs Metrics Server through the kind add-on. The last two checks wait up to about two minutes for metrics and for the new replica.
