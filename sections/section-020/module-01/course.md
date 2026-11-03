---
draft: true
exam_objectives:
  - Cloud Native Ecosystem and Principles
---
# Cloud Native Design

A cloud native application is built so that the platform can start, stop, move and copy its parts without a person stepping in. That goal drives every design rule in this module. A workload that keeps important data inside one container, ignores its own health or depends on one fixed address cannot be replaced safely. A workload that keeps data elsewhere, reports its health and talks through stable names can be replaced at any time.

This module explains the design rules and the Kubernetes mechanisms that enforce them. It starts with loose coupling, microservice tradeoffs and the settings that make a Deployment resilient: replicas, health probes, a PodDisruptionBudget, resource requests and configuration that lives outside the image. It then moves to workloads that run only when there is work to do. Serverless platforms start containers on demand. Event-driven systems pass work through queues, and they must handle retries and duplicates, so the module ends with Kubernetes Jobs, CronJobs and idempotent processing.

The module has four deep-dive parts. The first one covers boundaries, resilience and replaceable workloads. The second one covers serverless execution, event delivery, retries and idempotency. The third one covers the twelve-factor methodology and immutable infrastructure. The fourth one covers container design patterns such as the sidecar. The first two parts each end with a graded lab on the playground cluster.

## Learning objectives

After this module you can:

- Explain loose coupling and the cost and benefit of splitting an application into microservices.
- Configure replicas, readiness probes, liveness probes, resource requests and a PodDisruptionBudget so that a workload survives failures and node maintenance.
- Move configuration out of a container image into a ConfigMap and explain why durable state belongs outside the container.
- Explain what serverless means, why servers still exist, and what scale to zero and cold start are.
- Explain at-most-once and at-least-once delivery, and make a handler safe for retries with an idempotency key.
- Configure a Kubernetes Job and CronJob with retry limits, a deadline and a concurrency policy.

## Before you start

You need Kubernetes basics: pods, Deployments, Services, namespaces, and the commands `kubectl get`, `kubectl apply`, `kubectl describe` and `kubectl logs`. You do not need any extra tool.

Your playground is a single-node `kind` cluster running Kubernetes 1.35. `kubectl` points at it as the cluster administrator.

| Namespace | What is in it |
| --- | --- |
| `starfleet` | `scout`, a `podinfo` web application with one replica, no probes, no resource requests and an inline environment variable. `probe`, an HTTP test server (`go-httpbin`). `shuttle`, a pod that has `curl` for sending requests |
| `outpost` | `drifter`, a second pod with `curl` that runs outside `starfleet` |

Launch your playground now, and keep it running next to you while you read the parts:

<!-- astrona:playground -->
