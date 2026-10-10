---
draft: true
exam_objectives:
  - Observability
---
# Metrics, Logs And Traces

Users report that `scout` became slow after a release. Observability is the ability to reason about a system's internal behavior using evidence it produces. Telemetry is recorded information about that behavior. Different telemetry forms answer different questions, so one dashboard is rarely sufficient for every diagnosis.

A metric is a numerical measurement recorded over time. Request count, latency distributions and memory use can show trends and aggregate behavior. A counter accumulates events; a gauge measures a value that can rise or fall. Histograms capture observations in buckets to support distribution analysis. An average can hide a slow minority of requests, so latency percentiles and distributions can matter.

A log records an event with contextual data. It can show a specific error, input category or transition. Structured fields such as timestamps and request identifiers help connect related records without relying on free-text searches. Logs need retention and access controls because they can contain sensitive information.

A trace records the timed operations of a request across components. A span describes one operation and its relationship to other spans. Trace context propagated between services lets a system connect downstream work to the original request. Sampling selects which traces are retained, so absence of a trace is not proof that no request occurred.

For widespread latency growth, metrics can identify when and how often it happens. A trace can show where a sampled slow request spent time. Logs can explain the associated timeout or validation error. These forms complement one another rather than forming an order where one replaces all the others.

Compare telemetry with the user's symptom. A low CPU graph does not prove that an external database is fast. Evidence should cover the operations and dependencies relevant to the observed behavior.

## Choosing A Signal From A Question

A request success metric can show that failures rose from a small fraction to a large fraction after a release. It does not necessarily identify one failed request or its internal steps. A log can show a database timeout for a particular request. A trace can show that most of its duration was spent in that database call. The combined evidence connects population impact with a concrete mechanism.

Metric aggregation needs units and a defined population. A latency measurement in seconds should not be compared directly with another in milliseconds. A rate of failed requests needs both the failure definition and the total eligible requests. Removing difficult requests from the denominator can improve a number while making it less representative of users.

A counter normally increases during one process lifetime and can reset when that process restarts. A query computing a rate should account for that behavior. A gauge can rise or fall, such as queue depth. A histogram groups observations by thresholds and can support distribution analysis. The chosen type determines which calculations are meaningful.

## Correlation And Missing Evidence

Request context helps connect events between processes. A trace's spans represent operations with timing and parent relationships; they are not simply log lines renamed. Missing context propagation can fragment one user request into unrelated traces. Sampling and retention can also remove evidence that once existed.

A log stream can be incomplete because a process buffered output, a collector failed or retention expired. A trace can be absent because the request was not sampled. A metric can be stale because scraping stopped. Distinguish actual quiet behavior from a failed observation path before concluding that no work or error occurred.

Use signals to answer specific questions: how many users were affected, where time was spent and which error occurred. Then connect those observations through timestamps and context. Collecting all possible data without a question can increase cost and sensitive-data exposure without improving diagnosis.

## Common pitfalls

> [!WARNING]
> An average can hide tail latency, and sampled traces do not record every request. Low resource use is not proof of healthy user behavior.
