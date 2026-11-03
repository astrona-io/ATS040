---
estimated_duration: 25m
---

# Lab: Scrape And Alert On The scout Error Budget

Graded lab for the observability module. Prometheus in `monitoring` scrapes only itself and has an empty rules file. `scout` in `starfleet` already exposes metrics, and `shuttle` sends it a steady stream of requests, about one in ten of them failing with HTTP 500. The task is in `question.md`; the walkthrough is in `solution.md`.

Status: UNTESTED. Written and statically checked only.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS040.git -c sections/section-010/module-01/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS040.git -c sections/section-010/module-01/labs/lab-01
astrona destroy ats-040-lab-010-01
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-scout-job.sh` | The Prometheus targets API lists an active target in job `scout` at `scout.starfleet.svc.cluster.local:9898` with scrape interval 10s and label `env=lab` |
| `validate-scout-up.sh` | `up{job="scout"}` returns 1 |
| `validate-recording-rule.sh` | A recording rule `scout:http_error_ratio:rate5m` is loaded, uses `http_requests_total` and returns a ratio between 0.03 and 0.3 |
| `validate-alert-rule.sh` | Alert `ScoutErrorBudgetBurn` uses the recorded ratio with threshold 14.4 * 0.001, `for` 2m, label `severity=page` and a `summary` annotation |
| `validate-alert-firing.sh` | The `ALERTS` series for `ScoutErrorBudgetBurn` is firing |
| `validate-prometheus-ready.sh` | Prometheus answers `/-/ready` and `shuttle` is running. Passes before any change, fails if a change breaks either |
