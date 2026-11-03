---
estimated_duration: 30m
---

# Lab: Observability Capstone

Integration capstone for the observability section. The learner connects Prometheus to beacon, records its error ratio and writes burn-rate and availability alerts for a 99.5 percent objective. The task is in `question.md`; the walkthrough is in `solution.md`.

Status: UNTESTED. Written and statically checked only. The validation scripts and the reference solution have not been run.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS040.git -c sections/section-010/capstone/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS040.git -c sections/section-010/capstone/labs/lab-01
astrona destroy ats-040-capstone-010
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-prometheus-ready.sh` | Prometheus is Ready and drifter is still running |
| `validate-beacon-up.sh` | The job beacon scrapes beacon every 10 seconds with the label team=orbit and the target is up |
| `validate-recording-rule.sh` | Recording rule beacon:http_error_ratio:rate5m returns a plausible 5xx ratio |
| `validate-burn-alert.sh` | Alert BeaconErrorBudgetBurn uses 14.4 times the allowed ratio of a 99.5 percent objective, for 2 minutes, severity page |
| `validate-down-alert.sh` | Alert BeaconDown fires when up{job="beacon"} is 0 for 1 minute with severity page and a summary |
| `validate-slo-record.sh` | ConfigMap beacon-slo records the objective, the allowed ratio and the 30 day budget in minutes |
