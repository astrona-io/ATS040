# Question

Solve this question on: `terminal`

The `beacon` application in `orbit` serves users and exposes Prometheus metrics on port 9898. The `drifter` pod sends it a steady stream of requests, and about one in ten fails with HTTP 500. The team has agreed on a 99.5% availability objective measured over 30 days. Prometheus in `monitoring` does not know about `beacon` yet. It reads its configuration from the ConfigMap `prometheus-config` (key `prometheus.yml`) and its rules from the ConfigMap `prometheus-rules` (key `rules.yml`), and it runs with `--web.enable-lifecycle`. Keep `drifter` running and keep Prometheus Ready.

Deliver the following.

1. Prometheus scrapes `beacon` every 10 seconds in a job named `beacon`, and every series from it carries the label `team` with the value `orbit`.
2. A recording rule `beacon:http_error_ratio:rate5m` holds the ratio of 5xx requests to all requests for `beacon`, over 5 minutes.
3. An alert `BeaconErrorBudgetBurn` pages when the budget is spent 14.4 times faster than allowed, for 2 minutes.
4. An alert `BeaconDown` pages when the target cannot be scraped for 1 minute. Both alerts carry the label `severity` and a `summary` annotation.
5. A ConfigMap `beacon-slo` in `orbit` records the objective as `objective`, the allowed error ratio as `allowed-error-ratio` and the error budget in minutes over 30 days as `error-budget-minutes-30d`.

A new rule needs about a minute of data before its value appears.
