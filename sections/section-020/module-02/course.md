---
draft: true
exam_objectives:
  - Cloud Native Ecosystem and Principles
---
# Cloud Native Ecosystem

Kubernetes does not run containers, configure networks or store data by itself. It calls other software through defined interfaces: a runtime for containers, a plugin for pod networking, a driver for storage. Because the interfaces are open standards, a cluster operator can replace one implementation with another without changing Kubernetes or the applications. The cloud native ecosystem is the set of projects, products and managed services that implement these interfaces or build on top of the Kubernetes API.

This module explains which standards exist, what each one defines and where it sits in the path from a pod specification to a running container. It separates three things that people often mix up: a specification, an implementation of it and a managed service that hosts an implementation. It then shows how to match a platform job, such as collecting metrics or controlling traffic, to a project category, and how projects add their own objects to the Kubernetes API with custom resources.

The module has two deep-dive parts. The first part covers open standards and the boundary between specification, implementation and managed service. The second part covers project roles and the extension mechanism that most projects use. A graded lab at the end reads real values from the cluster and creates a custom resource type.

## Learning objectives

After this module you can:

- Explain what the Open Container Initiative, the Container Runtime Interface, the Container Network Interface and the Container Storage Interface each define.
- Distinguish a specification, an implementation and a managed service, and name one of each.
- Find the container runtime and the storage provisioner of a cluster with `kubectl`.
- Match representative projects to the platform job they do.
- Explain what a CustomResourceDefinition, a custom resource and a controller are, and how the API server validates a custom resource.

## Before you start

You need Kubernetes basics: nodes, pods, namespaces, and the commands `kubectl get`, `kubectl apply` and `kubectl describe`.

Your playground is a single-node `kind` cluster running Kubernetes 1.35, with no extra projects installed.

| Namespace | What is in it |
| --- | --- |
| `starfleet` | `scout`, a `podinfo` web application, and `shuttle`, a pod with `curl` |

`kubectl` points at the cluster as the cluster administrator.

Launch your playground now, and keep it running next to you while you read the parts:

<!-- astrona:playground -->
