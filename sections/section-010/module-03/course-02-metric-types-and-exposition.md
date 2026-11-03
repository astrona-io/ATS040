---
draft: true
exam_objectives:
  - Observability
---
# Metric Types And Exposition

A metric name alone does not say how to read it. Is the number a total that only grows, a value that goes up and down, or a distribution? The answer decides which query is correct. Prometheus defines four metric types for this. This part explains each type, the text format in which applications expose them and the exporters that expose the metrics of systems that cannot do it themselves.

## The exposition format

An application exposes metrics as plain text over HTTP, usually at `/metrics`. Each metric has a `# HELP` line with a description, a `# TYPE` line with the metric type and then one line per series:

```text
# HELP http_requests_total Total number of HTTP requests
# TYPE http_requests_total counter
http_requests_total{method="GET",status="200"} 1027
http_requests_total{method="GET",status="500"} 3
```

Read the metrics of the `scout` pod from the `shuttle` pod:

<!-- astrona:playground:renew -->

```sh
kubectl -n starfleet exec deploy/shuttle -- curl -s http://scout:9898/metrics
```

The output is long. Page through it or filter it with `grep` for the lines that start with `http_`:

```sh
kubectl -n starfleet exec deploy/shuttle -- sh -c "curl -s http://scout:9898/metrics | grep '^http_'"
```

## Counter

A **counter** is a value that only goes up, or resets to zero when the process restarts. It counts events: requests, errors, bytes sent. Its name ends in `_total` by convention. The raw value is rarely useful, because it depends on how long the process has run. Query its rate of change with `rate()`.

## Gauge

A **gauge** is a value that goes up and down. It shows a current state: memory in use, the number of pods that are ready, the length of a queue, a temperature. Read a gauge directly, or with functions such as `avg_over_time` and `max_over_time`. Do not apply `rate()` to a gauge.

## Histogram

A **histogram** samples observations, usually durations or sizes, and counts them in configurable buckets. One histogram creates several series:

- `<name>_bucket{le="0.5"}` is the count of observations less than or equal to 0.5. The label `le` means "less than or equal". Buckets are cumulative.
- `<name>_sum` is the sum of all observed values.
- `<name>_count` is the number of observations.

A histogram lets the server calculate quantiles, such as the 95th percentile, from the buckets with `histogram_quantile`, and the result can be aggregated across many instances. Its precision depends on the bucket boundaries: a quantile is an estimate inside one bucket. Choose boundaries around the values of your service level objective.

## Summary

A **summary** also observes values, but it calculates the quantiles inside the application and exposes them as `<name>{quantile="0.95"}`, plus `_sum` and `_count`. The quantiles are exact for one instance and cannot be averaged or aggregated across instances. For that reason a histogram is the usual choice in Kubernetes, where there are many replicas.

| Type | Goes | Typical use | Query with |
| --- | --- | --- | --- |
| Counter | Up only | Requests, errors, bytes | `rate`, `increase` |
| Gauge | Up and down | Memory, queue length, ready pods | Direct value, `avg_over_time` |
| Histogram | Buckets | Latency, size | `histogram_quantile` over `rate` of buckets |
| Summary | Client-side quantiles | Latency of a single instance | The quantile series directly |

## Naming conventions

Names use lowercase words with underscores. The unit goes in the name and base units are preferred: `_seconds`, `_bytes`, `_ratio`. A counter ends in `_total`. A name carries the thing that is measured, for example `http_request_duration_seconds`. Dimensions go in labels and not in the name.

## Exporters and built-in metrics

Many systems do not expose Prometheus metrics. An **exporter** is a small program that reads the metrics of such a system and exposes them in the Prometheus format. Three exporters are important in Kubernetes:

- **node-exporter** exposes the hardware and operating system metrics of a node: CPU, memory, disk and network.
- **kube-state-metrics** listens to the Kubernetes API and exposes the state of objects, such as the number of ready replicas of a Deployment or the phase of a pod. It does not measure usage.
- **cAdvisor** is built into the kubelet and exposes the CPU and memory usage of containers.

The difference matters for questions: kube-state-metrics says what Kubernetes wants and has, and cAdvisor says what a container uses.

## Summing up and what is still open

Applications expose text with `# TYPE` lines. Counters only grow and need `rate`. Gauges show a current value. Histograms give aggregatable quantiles and summaries give per-instance quantiles. Exporters bring in systems that do not speak the format. With data in the database, the next step is to ask questions with PromQL.

## Common pitfalls

> [!WARNING]
> - **Graphing a raw counter.** It only rises. Use `rate` or `increase`.
> - **Using `rate` on a gauge.** The result has no meaning.
> - **Averaging summary quantiles.** The average of two 95th percentiles is not the 95th percentile of the whole.
> - **Mixing up kube-state-metrics and cAdvisor.** One reports object state, the other reports usage.
> - **Bucket boundaries that miss the objective.** A quantile can only be as exact as its buckets.
