---
draft: true
exam_objectives:
  - Observability
---
# OpenTelemetry, Tracing And Logs

A single user request can pass through a dozen services. When it is slow or fails, one number from one service does not say where the time went. Teams need telemetry that is produced in a common format, collected in one place and linked across services, so that a request can be followed from the first service to the last.

This module explains how that works in the cloud native ecosystem. OpenTelemetry (OTel) is the CNCF project that defines the common format and the libraries that produce it. The OpenTelemetry Collector receives, changes and forwards telemetry. Distributed tracing links the work of many services into one trace. Logging in Kubernetes has its own rules, because a container writes its logs to a stream that a node component stores and another component ships. In the playground you read the telemetry settings of a real workload and practice the log commands.

The module has four deep-dive parts. The first part covers the OpenTelemetry signals, the instrumentation libraries and the standard settings. The second part covers the Collector and its pipelines. The third part covers distributed tracing, context propagation and sampling. The fourth part covers how logs work in Kubernetes and how they are collected. A graded lab after the second part asks you to configure a workload and a Collector configuration.

## Learning objectives

After this module you can:

- Name the OpenTelemetry signals and explain what the API, the SDK and OTLP each do.
- Set the standard OpenTelemetry environment variables on a workload.
- Describe the receivers, processors, exporters and pipelines of the Collector.
- Explain what a trace, a span and a trace context are, and how the context moves between services.
- Explain head sampling and tail sampling and the cost they control.
- Describe where container logs are stored and three ways to collect them.

## Before you start

You need Kubernetes basics: Deployments, ConfigMaps, and the commands `kubectl get`, `kubectl apply`, `kubectl logs` and `kubectl describe`.

Your playground is a single-node `kind` cluster running Kubernetes 1.35.

| Namespace | What is in it |
| --- | --- |
| `starfleet` | `scout`, a `podinfo` web application, `shuttle`, a pod with `curl`, and `collector-config`, a ConfigMap with a sample Collector configuration |

`kubectl` points at the cluster as the cluster administrator.

Launch your playground now, and keep it running next to you while you read the parts:

<!-- astrona:playground -->
