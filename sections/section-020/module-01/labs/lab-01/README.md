---
estimated_duration: 20m
---

# Lab: Build A Resilient Replaceable Workload

Graded lab for the cloud native design module. `scout` starts with one replica, no probes, no requests and an inline setting. The task is in `question.md`; the walkthrough is in `solution.md`.

Status: UNTESTED. Written and statically checked only. The validation scripts and the reference solution have not been run.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS040.git -c sections/section-020/module-01/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS040.git -c sections/section-020/module-01/labs/lab-01
astrona destroy ats-040-lab-020-01
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-replicas.sh` | scout has three replicas, all available |
| `validate-probes.sh` | scout has a readiness probe on /readyz and a liveness probe on /healthz |
| `validate-requests.sh` | scout declares cpu and memory requests |
| `validate-config.sh` | PODINFO_UI_MESSAGE comes from the ConfigMap scout-config, not from an inline value |
| `validate-pdb.sh` | A PodDisruptionBudget keeps at least two scout pods |
| `validate-serves.sh` | shuttle gets HTTP 200 from scout |
