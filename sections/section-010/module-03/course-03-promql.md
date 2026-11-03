---
draft: true
exam_objectives:
  - Observability
---
# PromQL

The database holds thousands of series. A person wants answers: how many requests per second, which pods fail, how slow is the 95th percentile. The Prometheus Query Language (PromQL) is the functional language that turns series into those answers. This part builds queries step by step, from a selector to a latency quantile, and each step can be run in the playground.

## How to run a query

The playground has no browser access to Prometheus, so run queries from the `shuttle` pod with the HTTP API. Define a helper function in your shell so that each query is one short line:

<!-- astrona:playground:renew -->

```sh
promql() { kubectl -n starfleet exec deploy/shuttle -- curl -s -G http://prometheus.monitoring.svc.cluster.local:9090/api/v1/query --data-urlencode "query=$1"; }
```

The function sends the query to the endpoint `/api/v1/query`, which evaluates an expression at the current time. The scrape job for `scout` is not in the playground yet. Add it first. Save this as `prometheus-config.yaml`:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: prometheus-config
  namespace: monitoring
data:
  prometheus.yml: |
    global:
      scrape_interval: 15s
      evaluation_interval: 15s
    rule_files:
      - /etc/prometheus/rules/*.yml
    scrape_configs:
      - job_name: prometheus
        static_configs:
          - targets: ["localhost:9090"]
      - job_name: scout
        static_configs:
          - targets: ["scout.starfleet.svc.cluster.local:9898"]
```

Apply it and restart Prometheus so that it reads the new file:

```sh
kubectl apply -f prometheus-config.yaml
kubectl -n monitoring rollout restart deployment/prometheus
kubectl -n monitoring rollout status deployment/prometheus
```

Wait about a minute for the first scrapes. The `shuttle` pod sends requests to `scout`, so the counters rise.

## Selectors and matchers

The simplest query is a metric name, which returns every series with that name. Braces filter by label. These are the matchers:

| Matcher | Meaning |
| --- | --- |
| `=` | The label equals the value |
| `!=` | The label does not equal the value |
| `=~` | The label matches the regular expression |
| `!~` | The label does not match the regular expression |

```sh
promql 'up{job="scout"}'
promql 'http_requests_total{job="scout", status=~"5.."}'
```

The result of a selector is an **instant vector**: one value per series at one moment. Adding a duration in square brackets, as in `http_requests_total[5m]`, makes a **range vector**: all samples of each series in the last five minutes. Functions such as `rate` need a range vector.

## rate and increase

A counter rises forever, so the useful question is how fast it rises. `rate(v[5m])` returns the per-second average increase over the last five minutes and handles counter resets. `increase(v[5m])` returns the total increase over the window and is `rate` multiplied by 300 seconds.

```sh
promql 'rate(http_requests_total{job="scout"}[5m])'
```

Choose a window of at least four times the scrape interval, so that it always contains several samples. With a 15 second interval, `[1m]` is the smallest sensible window and `[5m]` is common.

## Aggregation

The query above returns one series per label combination. Aggregation operators combine series: `sum`, `avg`, `min`, `max`, `count` and `topk`. The clauses `by` and `without` choose which labels to keep.

```sh
promql 'sum(rate(http_requests_total{job="scout"}[5m]))'
promql 'sum by (status) (rate(http_requests_total{job="scout"}[5m]))'
```

The first query returns the total request rate of the job. The second returns one rate per status code. Always apply `rate` first and then `sum`: summing raw counters hides the resets of individual series.

## An error ratio

Arithmetic works between vectors. The ratio of errors to all requests divides one aggregated rate by another:

```text
sum(rate(http_requests_total{job="scout", status=~"5.."}[5m]))
/
sum(rate(http_requests_total{job="scout"}[5m]))
```

When no request failed, the numerator has no series and the division returns an empty result and not zero. Use `or vector(0)` on the numerator when an alert must not go silent.

## Latency quantiles from a histogram

For a histogram, apply `rate` to the `_bucket` series, sum by the `le` label and pass the result to `histogram_quantile`:

```text
histogram_quantile(0.95, sum by (le) (rate(http_request_duration_seconds_bucket{job="scout"}[5m])))
```

The result is the estimated duration, in seconds, below which 95 percent of the requests finished. The `le` label must be kept in the `sum by`, because the function needs the buckets. To get one quantile per route or per pod, keep that label too: `sum by (le, path)`.

## Other useful functions

- `offset 1h` compares with the past: `rate(x[5m] offset 1h)`.
- `avg_over_time(v[1h])` and `max_over_time(v[1h])` work on gauges.
- `predict_linear(v[1h], 4 * 3600)` estimates the value in four hours from the trend of the last hour.
- `absent(v)` returns `1` when the metric has no series, which is how to alert on a missing target.
- `up == 0` lists the targets that are down.

## Summing up and what is still open

A PromQL query selects series with label matchers, turns counters into rates, aggregates with `sum by`, combines vectors with arithmetic and estimates quantiles from histogram buckets. These queries become recording rules to save work and alerting rules to notify people. The last part covers the alerting chain and the dashboards.

## Common pitfalls

> [!WARNING]
> - **`sum` before `rate`.** Sum the rates, never the raw counters.
> - **Dropping `le` in `sum by`.** `histogram_quantile` then has no buckets and returns nothing.
> - **A `rate` window shorter than two scrape intervals.** The result is empty or noisy.
> - **Reading an empty result as zero.** A selector that matches no series returns nothing, not zero.
> - **Expecting an exact quantile.** A histogram quantile is an estimate within the bucket boundaries.
