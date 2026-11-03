---
draft: true
exam_objectives:
  - Cloud Native Ecosystem and Principles
---
# Autoscaling

A fixed number of replicas is wrong most of the time. Too few replicas make the application slow or unavailable when load rises. Too many replicas waste CPU and memory when load falls. Autoscaling lets the cluster change capacity from measured signals instead of from a person watching a graph.

Kubernetes autoscales in three directions. Horizontal scaling changes the number of pods. Vertical scaling changes the CPU and memory of each pod. Cluster scaling changes the number of nodes that the pods run on. Each direction uses a different controller, reads different signals and has different limits. This module explains the mechanism of each one, then shows how event-driven projects such as KEDA scale on signals that are not CPU, and how scaling behavior is tuned so that replica counts do not oscillate.

The module has three deep-dive parts. The first part covers the Horizontal Pod Autoscaler and the metrics pipeline it depends on. The second part covers vertical and cluster scaling and how they relate to resource requests. The third part covers event-driven scaling and the rules that control how fast replicas change. A graded lab at the end gives a workload that cannot autoscale and asks you to make it scale.

## Learning objectives

After this module you can:

- Explain how Metrics Server, the HorizontalPodAutoscaler and the Deployment controller work together.
- Calculate the replica count that the Horizontal Pod Autoscaler chooses from a utilization value.
- Explain why a CPU resource request is required for percentage-based CPU scaling.
- Distinguish horizontal, vertical and cluster autoscaling and name a project for each.
- Describe how KEDA scales on external events and to zero, and how stabilization windows prevent oscillation.

## Before you start

You need Kubernetes basics: Deployments, resource requests and limits, and the commands `kubectl get`, `kubectl apply` and `kubectl describe`.

Your playground is a single-node `kind` cluster running Kubernetes 1.35, with Metrics Server installed so that `kubectl top` works.

| Namespace | What is in it |
| --- | --- |
| `starfleet` | `scout`, a `podinfo` web application with a CPU request, and `shuttle`, a pod with `curl` |

`kubectl` points at the cluster as the cluster administrator.

Launch your playground now, and keep it running next to you while you read the parts:

<!-- astrona:playground -->
