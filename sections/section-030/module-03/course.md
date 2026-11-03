---
draft: true
exam_objectives:
  - Cloud Native Community and Collaboration
---
# CNCF Structure And Kubernetes Governance

The Kubernetes and Cloud Native Associate (KCNA) exam asks who runs the CNCF, how a project moves from Sandbox to Graduated, how the Kubernetes project is organized and how a release is made. These questions test knowledge of the community and not of a command.

This module explains the structure of the Cloud Native Computing Foundation (CNCF) and the governance of Kubernetes. It starts with the CNCF bodies: the Governing Board, the Technical Oversight Committee (TOC) and the Technical Advisory Groups (TAGs). It then covers the Kubernetes Steering Committee, the Special Interest Groups (SIGs), working groups and Kubernetes Enhancement Proposals (KEPs), the release cycle and the Code of Conduct. In the playground you read the version facts of a live cluster and record them.

The module has four deep-dive parts. The first part covers the CNCF structure and the project lifecycle. The second part covers Kubernetes governance and KEPs. The third part covers the release cycle and version support. The fourth part covers the Code of Conduct and the ways to take part. A graded lab after the third part asks you to record release facts that match the live cluster.

## Learning objectives

After this module you can:

- Describe the role of the CNCF, the Governing Board, the TOC and the TAGs.
- Explain the Sandbox, Incubating and Graduated stages and what a project must show to move up.
- Describe the Kubernetes Steering Committee, SIGs, working groups and subprojects.
- Explain what a KEP is and how a feature moves from alpha to stable.
- Describe the Kubernetes release cycle and the versions that receive patches.
- State what the Code of Conduct requires and how to take part in the community.

## Before you start

You need Kubernetes basics: namespaces, ConfigMaps, and the commands `kubectl get`, `kubectl apply` and `kubectl version`.

Your playground is a single-node `kind` cluster running Kubernetes 1.35.

| Namespace | What is in it |
| --- | --- |
| `starfleet` | `scout`, a `podinfo` web application, and `shuttle`, a pod with `curl` |

`kubectl` points at the cluster as the cluster administrator.

Launch your playground now, and keep it running next to you while you read the parts:

<!-- astrona:playground -->
