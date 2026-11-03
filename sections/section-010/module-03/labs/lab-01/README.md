---
estimated_duration: 20m
---

# Lab: Record Latency And Alert On It With PromQL

Graded lab for the Prometheus module. Prometheus already scrapes scout. The learner writes two recording rules and one alerting rule in the rules ConfigMap. The task is in `question.md`; the walkthrough is in `solution.md`.

Status: UNTESTED. Written and statically checked only. The validation scripts and the reference solution have not been run.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS040.git -c sections/section-010/module-03/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS040.git -c sections/section-010/module-03/labs/lab-01
astrona destroy ats-040-lab-010-03
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-group.sh` | Rule group scout-latency is loaded and every rule is healthy |
| `validate-rate-rule.sh` | Recording rule scout:http_requests:rate5m sums rate of http_requests_total over 5m |
| `validate-p95-rule.sh` | Recording rule scout:http_request_duration_seconds:p95_5m uses histogram_quantile 0.95 over summed bucket rates by le |
| `validate-alert.sh` | Alert ScoutSlow fires above 0.5 for 5 minutes with label severity=ticket and a summary annotation |
