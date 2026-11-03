---
draft: true
exam_objectives:
  - Observability
---
# Summary

Prometheus pulls metrics. It scrapes the `/metrics` endpoint of each target at a fixed interval, stores the samples in a local time series database and marks every target with the metric `up`. A series is a metric name plus a set of labels. Labels give dimensions, and a label with unbounded values creates too many series. Short-lived jobs push to the Pushgateway, and exporters expose the metrics of systems that do not speak the format.

A counter only grows and is read with `rate` or `increase`. A gauge goes up and down and is read directly. A histogram counts observations in cumulative buckets and gives quantiles that can be aggregated, and a summary calculates quantiles in the application and cannot be aggregated. Kube-state-metrics reports the state of Kubernetes objects, node-exporter reports node resources and cAdvisor reports container usage.

PromQL selects series with label matchers, turns range vectors into rates, aggregates with `sum by`, divides vectors to form ratios and estimates quantiles with `histogram_quantile` over summed bucket rates. The rule is to apply `rate` first and then aggregate.

Recording rules save the result of a query as a new series. An alerting rule fires when its condition lasts for the `for` duration. Alertmanager groups, routes, inhibits and silences the alerts that Prometheus sends, and delivers them to receivers. Grafana draws dashboards from data sources, and the Prometheus Operator manages the stack with custom resources such as `ServiceMonitor` and `PrometheusRule`.

- Prometheus keeps 15 days of data by default.
- Alert on symptoms that users feel, and use causes for diagnosis.
- Prometheus evaluates rules and Alertmanager sends notifications.
- A query that matches no series returns an empty result and not zero.

<!-- astrona:playground:destroy -->
