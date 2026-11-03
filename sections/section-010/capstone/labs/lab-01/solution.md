# Solution

Solve this capstone on `terminal`. Each step ends with `astrona submit`, which grades the current state.

Start the lab if it is not running:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS040.git -c sections/section-010/capstone/labs/lab-01
```

## Step 1: Work out the numbers

A 99.5% objective allows an error ratio of 0.005. The 30 day period has 30 * 24 * 60 = 43200 minutes, so the budget is 0.005 * 43200 = 216 minutes. A burn rate of 14.4 means the budget is spent 14.4 times faster than allowed, so the alert threshold is 14.4 * 0.005 = 0.072.

## Step 2: Add the scrape job

Edit `prometheus-config` (`kubectl -n monitoring edit configmap prometheus-config`) and add a job under `scrape_configs`:

```yaml
      - job_name: beacon
        scrape_interval: 10s
        static_configs:
          - targets: ["beacon.orbit.svc.cluster.local:9898"]
            labels:
              team: orbit
```

## Step 3: Add the rules

Edit `prometheus-rules` and replace `groups: []` with:

```yaml
    groups:
      - name: beacon-slo
        rules:
          - record: beacon:http_error_ratio:rate5m
            expr: sum(rate(http_requests_total{job="beacon",status=~"5.."}[5m])) / sum(rate(http_requests_total{job="beacon"}[5m]))
          - alert: BeaconErrorBudgetBurn
            expr: beacon:http_error_ratio:rate5m > 14.4 * 0.005
            for: 2m
            labels:
              severity: page
            annotations:
              summary: beacon is spending its 99.5% error budget 14.4 times too fast
          - alert: BeaconDown
            expr: up{job="beacon"} == 0
            for: 1m
            labels:
              severity: page
            annotations:
              summary: beacon cannot be scraped
```

Restart Prometheus so that it reads both ConfigMaps. A ConfigMap volume update can take about a minute to reach the pod, and a restart is the reliable way:

```sh
kubectl -n monitoring rollout restart deployment/prometheus
kubectl -n monitoring rollout status deployment/prometheus
```

## Step 4: Record the objective

Save this as `beacon-slo.yaml`:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: beacon-slo
  namespace: orbit
data:
  objective: "99.5"
  allowed-error-ratio: "0.005"
  error-budget-minutes-30d: "216"
```

Apply it:

```sh
kubectl apply -f beacon-slo.yaml
```

## Step 5: Grade

Wait about two minutes for the first rule evaluation, then submit:

```sh
astrona submit --git ssh://git@github.com/astrona-io/ATS040.git -c sections/section-010/capstone/labs/lab-01
```

All six checks pass when Prometheus is Ready and scrapes `beacon`, the ratio is recorded, both alerts are defined correctly and the objective is recorded.
