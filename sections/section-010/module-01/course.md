---
draft: true
exam_objectives:
  - Observability
---
# Observability And Reliability

Users report that `scout` became slow after a release. The operator cannot attach a debugger to every pod, so the only evidence is the data the system produces about itself. Observability is the ability to explain a system's internal behavior from that data. The data is called telemetry, and it comes in three main forms: metrics, logs and traces. Each form answers a different question, and none of them replaces the others.

Producing telemetry is only the first step. Instrumentation adds the measurements to the code, a pipeline moves them to a storage system, and a query language turns them into answers. Prometheus is the most common open source system for metrics in Kubernetes. It pulls (scrapes) metrics from HTTP endpoints on a schedule, stores them as time series and evaluates rules on them. OpenTelemetry is the vendor-neutral standard for producing and moving all three signal types.

Once the data is trustworthy, it supports reliability decisions. A service level indicator (SLI) measures behavior, a service level objective (SLO) sets the target, and the error budget is the failure the target still allows. Alerts built on the rate at which the budget is spent page a person only when users are affected.

The module covers three subjects in order. The first is the three signal types and the properties that decide how useful they are: metric types, structured logs, spans, context propagation, sampling and cardinality. The second is how telemetry gets out of an application: OpenTelemetry components, the Prometheus scrape mechanism, scrape configuration and the path from a scrape to a query. The third is SLIs, SLOs, error budget arithmetic, burn rate and Prometheus recording and alerting rules.

## Learning objectives

After this module you can:

- Choose metrics, logs or traces for a diagnostic question, and name the limits of each signal.
- Explain the OpenTelemetry API, SDK and Collector, and describe how Prometheus scrapes a target.
- Read a Prometheus scrape configuration and rule file and say what each field does.
- Calculate an error budget and a burn rate for a given SLO and window.
- Write a recording rule and an alerting rule that page on fast error budget consumption.

## Before you start

You need Kubernetes basics: namespaces, pods, Deployments, Services, ConfigMaps, and the commands `kubectl get`, `kubectl apply`, `kubectl logs` and `kubectl exec`. No monitoring tool experience is needed.

Your playground is a single-node `kind` cluster running Kubernetes 1.35:

| Namespace | What is in it |
| --- | --- |
| `monitoring` | Prometheus v3.5.0 with a configuration that scrapes only itself, an empty rules file, and a Service on port 9090 |
| `starfleet` | `scout` and `probe` (podinfo applications that expose `/metrics`) and `shuttle`, a curl pod that sends a steady stream of requests to `scout`, about one in ten of them failing with HTTP 500 |

`kubectl` already points at the playground cluster. Launch it now and keep it running while you read:

<!-- astrona:playground -->
