# Question

Solve this question on: `terminal`

The `scout` in `starfleet` exposes Prometheus metrics on port 9898, but Prometheus in the `monitoring` namespace does not scrape it. The `shuttle` pod sends `scout` a steady stream of requests, and about one in ten fails with HTTP 500. The team has agreed on a 99.9% availability objective for `scout` and wants a page when it spends its error budget fast.

Prometheus reads its configuration from the ConfigMap `prometheus-config` (key `prometheus.yml`) and its rules from the ConfigMap `prometheus-rules` (key `rules.yml`). It runs with `--web.enable-lifecycle`. Keep the Deployment `shuttle` running.

1. Add a scrape job named `scout` to `prometheus-config`. It scrapes the static target `scout.starfleet.svc.cluster.local:9898` every 10 seconds and adds the target label `env` with value `lab`.
2. Make Prometheus apply the new configuration, so that the query `up{job="scout"}` returns 1.
3. Add a recording rule named `scout:http_error_ratio:rate5m` to `prometheus-rules`. Its value is the rate of `scout` requests with a 5xx status over 5 minutes divided by the rate of all `scout` requests over 5 minutes.
4. Add an alerting rule named `ScoutErrorBudgetBurn` for the 99.9% objective. It fires when the recorded error ratio is greater than 14.4 times the allowed ratio of 0.001, for 2 minutes. It has the label `severity` with value `page` and an annotation `summary`.

Prometheus must stay Ready, so keep both files valid. A fixed alert needs a few minutes of data before it fires.
