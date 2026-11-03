---
estimated_duration: 20m
---

# Lab: Record Release Facts That Match The Cluster

Graded lab for the CNCF structure and governance module. The learner reads the server version of the live cluster and records release facts in a ConfigMap. The task is in `question.md`; the walkthrough is in `solution.md`.

Status: UNTESTED. Written and statically checked only. The validation scripts and the reference solution have not been run.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS040.git -c sections/section-030/module-03/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS040.git -c sections/section-030/module-03/labs/lab-01
astrona destroy ats-040-lab-030-03
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-exists.sh` | ConfigMap release-facts exists in starfleet |
| `validate-version.sh` | serverVersion matches the version of the cluster |
| `validate-cadence.sh` | releasesPerYear is 3 |
| `validate-support.sh` | supportedMinorVersions is 3 |
| `validate-annotation.sh` | The annotation owner-sig is sig-release |
