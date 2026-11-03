---
draft: true
exam_objectives:
  - Cloud Native Community and Collaboration
---
# API Maturity And Deprecation

Every Kubernetes manifest begins with `apiVersion`. That one line is a promise about stability. A manifest written for `policy/v1beta1` worked on one cluster version and stopped working on a later one, because the API server no longer serves that version. Teams that do not know how Kubernetes versions its API find out at upgrade time, when an apply fails or a controller breaks.

This module explains how Kubernetes labels the maturity of an API as alpha, beta or stable, what each label promises, and how the project deprecates and removes versions on a published schedule. It shows how to see which versions a cluster serves, how the API server warns about deprecated use, and how to migrate a manifest to the current version. The same rules apply to custom resources that projects add, so the module also explains why a project's own API version tells you how much to depend on it.

The module has four deep-dive parts. The first part covers maturity levels and feature gates. The second part covers the deprecation policy and how to find deprecated use. The third part covers migrating manifests. The fourth part covers custom resource versions and conversion. A graded lab at the end gives three manifests that use removed API versions and asks you to migrate them.

## Learning objectives

After this module you can:

- Read an apiVersion and say whether it is alpha, beta or stable.
- State what the Kubernetes deprecation policy promises for each level.
- Explain what a feature gate is and how it relates to API maturity.
- List the API groups and versions that a cluster serves.
- Migrate a manifest from a removed API version to the current one and check the result.

## Before you start

You need Kubernetes basics: Deployments, Services and the commands `kubectl get`, `kubectl apply` and `kubectl describe`.

Your playground is a single-node `kind` cluster running Kubernetes 1.35.

| Namespace | What is in it |
| --- | --- |
| `starfleet` | `scout`, a `podinfo` web application with a CPU request, and `shuttle`, a pod with `curl` |

`kubectl` points at the cluster as the cluster administrator.

Launch your playground now, and keep it running next to you while you read the parts:

<!-- astrona:playground -->
