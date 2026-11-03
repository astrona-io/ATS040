# Overview: Observability And Reliability (Playground)

This is a **playground**, not a lab. It starts a fresh cluster with Prometheus and a few example workloads, and then waits. There is no task, no `astrona submit` and no pass or fail. Change the configuration, break it, `astrona destroy`, start over.

## What's in the box

- A single-node `kind` cluster running Kubernetes 1.35. `kubectl` is already pointed at it, as the cluster administrator.

  | Namespace | What is in it |
  | --- | --- |
  | `monitoring` | Prometheus v3.5.0 (`--web.enable-lifecycle`). ConfigMap `prometheus-config` (key `prometheus.yml`) has one job that scrapes Prometheus itself. ConfigMap `prometheus-rules` (key `rules.yml`) is empty. The Service `prometheus` listens on port 9090 |
  | `starfleet` | `scout` and `probe` (podinfo, port 9898, `/metrics`), each with a Service. `shuttle` (curl) requests `scout` every second, and every tenth request goes to `/status/500` |

## Helpers

Paste these once in each new terminal. `prom_query` runs a PromQL query through the Prometheus HTTP API from the `shuttle` pod. `prom_api` calls any other API path. `prom_reload` asks Prometheus to reload its configuration. `prom_restart` restarts Prometheus and waits for it.

```sh
prom_query() {
  kubectl -n starfleet exec deploy/shuttle -- curl -s -G http://prometheus.monitoring.svc.cluster.local:9090/api/v1/query --data-urlencode "query=$1"
}
prom_api() {
  kubectl -n starfleet exec deploy/shuttle -- curl -s "http://prometheus.monitoring.svc.cluster.local:9090$1"
}
prom_reload() {
  kubectl -n starfleet exec deploy/shuttle -- curl -s -X POST http://prometheus.monitoring.svc.cluster.local:9090/-/reload
}
prom_restart() {
  kubectl -n monitoring rollout restart deploy/prometheus && kubectl -n monitoring rollout status deploy/prometheus
}
```

Use them like this: `prom_query up`, `prom_api /api/v1/targets`, `prom_api /api/v1/rules`.

## Practice tasks

- Read the raw metrics of `scout` with `curl` and find the `http_requests_total` samples for status 200 and 500.
- Check that `prom_query 'up{job="scout"}'` returns no series, then explain why.
- Add a scrape job for `probe` to `prometheus-config`, apply it with `prom_restart`, and query `up{job="probe"}`.
- Write a recording rule for the 5xx ratio of `scout` in `prometheus-rules` and find it in `prom_api /api/v1/rules`.
- Calculate by hand the error budget in minutes of a 99.95% SLO over 28 days.
