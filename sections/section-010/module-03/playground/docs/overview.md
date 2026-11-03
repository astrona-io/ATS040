# Prometheus And PromQL Playground

A single-node kind cluster (Kubernetes 1.35). Nothing is graded.

## What is in the box

| Object | Namespace | Purpose |
| --- | --- | --- |
| Deployment and Service `prometheus` | `monitoring` | Prometheus v3.5.0 with the lifecycle API enabled. It scrapes only itself at the start. |
| ConfigMaps `prometheus-config` and `prometheus-rules` | `monitoring` | The configuration file and an empty rules file (`groups: []`) |
| Deployments `scout` and `probe` | `starfleet` | `podinfo` applications that expose `/metrics` on port 9898 |
| Deployment `shuttle` | `starfleet` | A pod with `curl` that sends requests to `scout` |

## Helper functions

```sh
promql() { kubectl -n starfleet exec deploy/shuttle -- curl -s -G http://prometheus.monitoring.svc.cluster.local:9090/api/v1/query --data-urlencode "query=$1"; }
reload_prometheus() { kubectl -n monitoring rollout restart deployment/prometheus && kubectl -n monitoring rollout status deployment/prometheus; }
```

## Practice tasks

1. Run `promql up` and find the one target. Add a job for `scout` to `prometheus-config`, restart Prometheus with `reload_prometheus` and run `promql up` again.
2. Read the raw metrics of `scout` with `curl` from `shuttle` and find a counter and a histogram by their `# TYPE` lines.
3. Query `sum by (status) (rate(http_requests_total{job="scout"}[5m]))`.
4. Query the 95th percentile of `http_request_duration_seconds` with `histogram_quantile`.
5. Put a recording rule in `prometheus-rules`, restart Prometheus and read `/api/v1/rules`.
