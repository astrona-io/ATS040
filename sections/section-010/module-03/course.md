---
draft: true
exam_objectives:
  - Observability
---
# Prometheus And PromQL

Prometheus is the metrics system that most Kubernetes clusters use, and it is a CNCF graduated project. The Kubernetes and Cloud Native Associate (KCNA) exam expects you to know how it collects data, which metric types exist, what a query in its language looks like and how alerts reach a person. Teams that skip these basics read dashboards without knowing what a line on the graph means.

This module explains the Prometheus architecture first: the pull model, targets, labels and the time series database. It then covers the four metric types and the text format that applications expose, the query language PromQL, and the alerting chain made of alerting rules, Alertmanager and Grafana. In the playground, Prometheus runs in the `monitoring` namespace and scrapes the `scout` application, so every query in the readings can be tried.

The module has four deep-dive parts. The first part covers the architecture and the data model. The second part covers metric types and exposition. The third part covers PromQL. The fourth part covers alerting and dashboards. A graded lab after the third part asks you to write recording and alerting rules for request latency.

## Learning objectives

After this module you can:

- Explain the pull model, scrape jobs, targets and the `up` metric.
- Describe a time series, a label and the problem of high cardinality.
- Choose between a counter, a gauge, a histogram and a summary.
- Write a PromQL query with a label matcher, `rate`, `sum by` and `histogram_quantile`.
- Explain what an alerting rule, the `for` clause and Alertmanager each do.
- Name the role of exporters, kube-state-metrics, node-exporter and Grafana.

## Before you start

You need Kubernetes basics: Deployments, Services, ConfigMaps, and the commands `kubectl get`, `kubectl apply` and `kubectl exec`.

Your playground is a single-node `kind` cluster running Kubernetes 1.35.

| Namespace | What is in it |
| --- | --- |
| `monitoring` | `prometheus` v3.5.0, which scrapes only itself at the start, and an empty rules file |
| `starfleet` | `scout` and `probe`, `podinfo` applications that expose `/metrics`, and `shuttle`, a pod with `curl` that sends requests |

`kubectl` points at the cluster as the cluster administrator.

Launch your playground now, and keep it running next to you while you read the parts:

<!-- astrona:playground -->
