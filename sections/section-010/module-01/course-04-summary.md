---
draft: true
exam_objectives:
  - Observability
---
# Summary

Metrics, logs and traces answer different questions. Metrics are cheap numbers over time that show how many requests are affected. Logs record single events with context and explain what happened. Traces connect timed spans across services through propagated context and show where time went. Counters, gauges and histograms support different calculations, structured logs make events searchable, and sampling means a missing trace proves nothing. Cardinality limits what labels a metric can carry.

Telemetry reaches a backend through instrumentation and a pipeline. The OpenTelemetry API is what code calls, the SDK implements it, and the Collector receives, processes and exports data. Prometheus pulls metrics by scraping targets listed in scrape jobs, stores samples in its time series database and answers PromQL queries. A metric that is not in a scrape job is not in Prometheus, and a configuration change applies only after a reload or restart.

An SLI measures behavior, an SLO sets a target over a window and an SLA is a contract. The error budget is one minus the SLO: 43.2 minutes in 30 days for 99.9%. Burn rate is the current error ratio divided by the allowed ratio, and a rate of 14.4 spends 2% of a 30-day budget in one hour. Recording rules store ratios, alerting rules use `expr`, `for`, `labels` and `annotations`, and pages should follow symptoms such as budget burn.

Key facts:

- Counters reset on restart, so queries use `rate()`.
- Unbounded values belong in logs and traces, not in metric labels.
- `up` is 1 when the last scrape succeeded and 0 when it failed.
- Allowed error ratio equals 1 minus the SLO.

<!-- astrona:playground:destroy -->
