---
draft: true
exam_objectives:
  - Cloud Native Ecosystem and Principles
---
# Serverless And Event-Driven Platforms

Serverless is a way to run code where the platform handles servers, scaling and idle time, and the team pays only for the work that runs. The Kubernetes and Cloud Native Associate (KCNA) exam asks what serverless means, how functions differ from containers, what Knative adds to Kubernetes and how event-driven design connects the pieces.

This module explains serverless computing in the cloud native ecosystem. It starts with the definition and the two forms of serverless: Functions as a Service and Backend as a Service. It then covers Knative Serving and Eventing, scale to zero and event-driven autoscaling, and the run-to-completion workloads that Kubernetes has built in. In the playground you create Jobs and CronJobs and read how a short-lived workload behaves.

The module has four deep-dive parts. The first part covers the serverless model and its trade-offs. The second part covers Knative Serving and Eventing. The third part covers scale to zero, event-driven scaling and batch workloads. The fourth part covers how to choose between serverless, containers and virtual machines. A graded lab after the third part asks you to create a Job and a CronJob with the right limits.

## Learning objectives

After this module you can:

- Define serverless and name the two forms, Functions as a Service and Backend as a Service.
- List the benefits and the limits of serverless, such as cold starts and lock-in.
- Explain what Knative Serving and Knative Eventing each provide.
- Explain scale to zero and event-driven autoscaling with KEDA.
- Create a Job and a CronJob with a deadline, a retry limit and automatic cleanup.
- Choose between serverless, containers and virtual machines for a workload.

## Before you start

You need Kubernetes basics: Pods, Deployments, and the commands `kubectl get`, `kubectl apply` and `kubectl logs`.

Your playground is a single-node `kind` cluster running Kubernetes 1.35 with the Metrics Server.

| Namespace | What is in it |
| --- | --- |
| `starfleet` | `scout`, a `podinfo` web application, and `shuttle`, a pod with `curl` |

`kubectl` points at the cluster as the cluster administrator.

Launch your playground now, and keep it running next to you while you read the parts:

<!-- astrona:playground -->
