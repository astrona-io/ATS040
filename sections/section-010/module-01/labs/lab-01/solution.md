# Solution

Four changes: a scrape job, a restart so Prometheus loads it, a recording rule and an alerting rule. The commands below use the Prometheus HTTP API from the `shuttle` pod, because Prometheus has no external address.

## Step 1: Look at the starting state

```sh
kubectl -n monitoring get configmap prometheus-config -o jsonpath='{.data.prometheus\.yml}'
kubectl -n starfleet exec deploy/shuttle -- curl -s -G http://prometheus.monitoring.svc.cluster.local:9090/api/v1/query --data-urlencode 'query=up'
```

The configuration has one job, `prometheus`, and the query returns one series. `scout` has no scrape job, so its metrics are not in Prometheus.

## Step 2: Add the scout scrape job

Edit the ConfigMap and add the job under `scrape_configs`:

```sh
kubectl -n monitoring edit configmap prometheus-config
```

The new list entry is:

```yaml
      - job_name: scout
        scrape_interval: 10s
        static_configs:
          - targets: ["scout.starfleet.svc.cluster.local:9898"]
            labels:
              env: lab
```

`job_name` sets the `job` label, the job-level `scrape_interval` overrides the global 15s, and `labels` adds `env=lab` to every series from the target. Keep the indentation the same as the `prometheus` job.

Run `astrona submit` to check the scrape job. It reports the job as configured only after Prometheus has loaded it, so continue with the next step first.

## Step 3: Make Prometheus apply the configuration

```sh
kubectl -n monitoring rollout restart deployment/prometheus
kubectl -n monitoring rollout status deployment/prometheus
```

Prometheus reads `prometheus.yml` at startup. The restart is the reliable way, because the kubelet needs up to a minute to copy a changed ConfigMap into the pod, and a reload before that reads the old file. Then query the target:

```sh
kubectl -n starfleet exec deploy/shuttle -- curl -s -G http://prometheus.monitoring.svc.cluster.local:9090/api/v1/query --data-urlencode 'query=up{job="scout"}'
```

The value of the series must be `1`. If the query returns no series, wait one scrape interval and ask again. Run `astrona submit` to check the job and `up`.

## Step 4: Add the recording rule

Edit the rules ConfigMap and replace `groups: []` with a group that holds the rule:

```sh
kubectl -n monitoring edit configmap prometheus-rules
```

```yaml
    groups:
      - name: scout-slo
        rules:
          - record: scout:http_error_ratio:rate5m
            expr: sum(rate(http_requests_total{job="scout",status=~"5.."}[5m])) / sum(rate(http_requests_total{job="scout"}[5m]))
```

The numerator selects only series whose `status` label starts with 5. `sum()` on both sides removes the `status` label so the division has matching label sets.

## Step 5: Add the alerting rule

Add the alert to the same `rules` list:

```yaml
          - alert: ScoutErrorBudgetBurn
            expr: scout:http_error_ratio:rate5m > 14.4 * 0.001
            for: 2m
            labels:
              severity: page
            annotations:
              summary: scout is spending its 99.9% error budget 14.4 times too fast
```

The 99.9% objective allows an error ratio of 0.001. Burn rate 14.4 means a ratio of 14.4 x 0.001 = 0.0144. Restart Prometheus again to load both rules, and confirm that it is Ready:

```sh
kubectl -n monitoring rollout restart deployment/prometheus
kubectl -n monitoring rollout status deployment/prometheus
kubectl -n starfleet exec deploy/shuttle -- curl -s http://prometheus.monitoring.svc.cluster.local:9090/api/v1/rules
```

The reply lists the group `scout-slo` with both rules. Run `astrona submit` to check the rules.

## Step 6: Wait for the alert

The loop in `shuttle` produces an error ratio of about 0.1, which is above 0.0144. The rate needs data from the new scrape job, and the rule must hold for 2 minutes, so the alert fires after about 3 to 5 minutes. Check it:

```sh
kubectl -n starfleet exec deploy/shuttle -- curl -s -G http://prometheus.monitoring.svc.cluster.local:9090/api/v1/query --data-urlencode 'query=ALERTS{alertname="ScoutErrorBudgetBurn"}'
```

The series carries `alertstate="pending"` first and `alertstate="firing"` once the `for` time has passed. Run `astrona submit` when it shows `firing`.

## Common mistakes

- Using `0.001` or `14.4` alone as the threshold, instead of 14.4 x 0.001.
- Forgetting `sum()` or putting the 5xx selector on both sides, which gives a ratio of 1 or no value.
- Writing invalid YAML or an invalid expression in the rules file, so Prometheus does not become Ready after the restart.
