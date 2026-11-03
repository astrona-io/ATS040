# Solution

Solve this lab on `terminal`. Each step ends with `astrona submit`, which grades the current state.

Start the lab if it is not running:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS040.git -c sections/section-010/module-03/labs/lab-01
```

## Step 1: Write the rules

Save this as `prometheus-rules.yaml`:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: prometheus-rules
  namespace: monitoring
data:
  rules.yml: |
    groups:
      - name: scout-latency
        rules:
          - record: scout:http_requests:rate5m
            expr: sum(rate(http_requests_total{job="scout"}[5m]))
          - record: scout:http_request_duration_seconds:p95_5m
            expr: histogram_quantile(0.95, sum by (le) (rate(http_request_duration_seconds_bucket{job="scout"}[5m])))
          - alert: ScoutSlow
            expr: scout:http_request_duration_seconds:p95_5m > 0.5
            for: 5m
            labels:
              severity: ticket
            annotations:
              summary: "scout p95 latency is above 0.5 seconds"
```

Apply it:

```sh
kubectl apply -f prometheus-rules.yaml
```

## Step 2: Load the rules

The kubelet needs up to about a minute to copy a changed ConfigMap into the pod. Restart Prometheus to read the file at once:

```sh
kubectl -n monitoring rollout restart deployment/prometheus
kubectl -n monitoring rollout status deployment/prometheus
```

## Step 3: Check the rules

```sh
kubectl -n starfleet exec deploy/shuttle -- curl -s http://prometheus.monitoring.svc.cluster.local:9090/api/v1/rules
```

Each rule shows `"health":"ok"` after the first evaluation, which runs within the evaluation interval of 15 seconds.

## Grade

```sh
astrona submit --git ssh://git@github.com/astrona-io/ATS040.git -c sections/section-010/module-03/labs/lab-01
```

All checks pass when the group exists, both recording rules use the right expressions, and the alert has the right condition, duration and label.
