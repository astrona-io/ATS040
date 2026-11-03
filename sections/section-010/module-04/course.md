---
draft: true
exam_objectives:
  - Observability
---
# Cloud Cost Management

Kubernetes makes it easy to start workloads and hard to see what they cost. A cluster is billed for the nodes, disks and network traffic that exist, not for the work that the pods do. A team that never looks at the bill finds out that a test environment has run at full size for months, or that every pod asks for ten times the CPU it uses.

This module explains cloud cost management for Kubernetes, which the exam places next to observability because cost is also a signal that has to be measured. It covers what drives cost, the practice called FinOps, how resource requests decide the size of the bill and how to right-size them, how cost is split between teams with labels and tools such as OpenCost, and the purchasing and scaling choices that lower the price. In the playground you read the requests and the usage of a workload, and you set quota and defaults on a namespace.

The module has four deep-dive parts. The first part covers cost drivers and FinOps. The second part covers requests, usage, quota and right-sizing. The third part covers allocation, labels and cost tools. The fourth part covers purchasing options and scaling levers. A graded lab after the second part asks you to apply a budget to a namespace and right-size a workload.

## Learning objectives

After this module you can:

- Name the main cost drivers of a Kubernetes cluster.
- Explain FinOps and its phases of inform, optimize and operate.
- Explain why resource requests, not usage, decide how many nodes a cluster needs.
- Set a ResourceQuota and a LimitRange on a namespace.
- Describe how labels and tools such as OpenCost allocate cost to teams.
- Compare on-demand, committed and spot capacity and name the workloads that suit each.

## Before you start

You need Kubernetes basics: Deployments, resource requests and limits, namespaces and labels, and the commands `kubectl get`, `kubectl apply` and `kubectl describe`.

Your playground is a single-node `kind` cluster running Kubernetes 1.35, with Metrics Server installed so that `kubectl top` works.

| Namespace | What is in it |
| --- | --- |
| `starfleet` | `scout`, a `podinfo` web application with a large CPU and memory request, and `shuttle`, a pod with `curl` |

`kubectl` points at the cluster as the cluster administrator.

Launch your playground now, and keep it running next to you while you read the parts:

<!-- astrona:playground -->
