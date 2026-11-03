# Question

Solve this question on: `terminal`

Prometheus in the namespace `monitoring` already scrapes the job `scout`. The `scout` application in `starfleet` exposes the counter `http_requests_total` and the histogram `http_request_duration_seconds`. The rules file is empty. The configuration reads every file under `/etc/prometheus/rules/` and the rules come from the ConfigMap `prometheus-rules`, key `rules.yml`.

1. Add a rule group named `scout-latency` to the file. In it, add a recording rule named `scout:http_requests:rate5m` that records the total per-second request rate of the job `scout` over 5 minutes.

2. Add a recording rule named `scout:http_request_duration_seconds:p95_5m` that records the 95th percentile of the request duration of the job `scout`, from the histogram buckets over 5 minutes.

3. Add an alerting rule named `ScoutSlow` that fires when the recorded 95th percentile is greater than 0.5 seconds for 5 minutes. Give it the label `severity` with the value `ticket` and an annotation `summary`.

4. Make Prometheus load the rules. All three rules must report a health of `ok`.

`kubectl` already points at the cluster as the cluster administrator.
