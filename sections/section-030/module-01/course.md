---
draft: true
exam_objectives:
  - Cloud Native Community and Collaboration
---
# Community And Collaboration

A cloud native project is more than its code. Decisions about its direction, its license, who may change it and how a change is accepted all affect whether a team can depend on it. A team that picks a project by download count and then discovers an incompatible license, or that sends a large change to a repository that does not want it, loses time that the code never cost.

This module explains how open source governance works in the cloud native ecosystem. It covers what the CNCF maturity levels say and do not say, how licenses and contribution rules differ, and how a contribution moves from an issue through review to a decision. It uses the Kubernetes community as the main example, with its Special Interest Groups and working groups. The playground lets you practice the evidence-keeping and review habits on a running cluster: you record the facts about a dependency, and you review a change with `kubectl diff` before it is applied.

The module has two deep-dive parts. The first part covers governance, maturity levels, licenses and contribution rules. The second part covers the issue, change and review workflow and how to find the right group. A graded lab at the end walks through one small contribution cycle on a live cluster.

## Learning objectives

After this module you can:

- Explain what Sandbox, Incubating and Graduated mean, and what they do not mean.
- Distinguish a license permission from a contribution requirement such as a Developer Certificate of Origin sign-off.
- Record the evidence for a dependency decision in a structured way.
- Describe the path from an issue through a pull request and review to a merge decision.
- Pick a Special Interest Group or working group from its scope.
- Review a proposed change to a Kubernetes object with a diff before applying it.

## Before you start

You need Kubernetes basics: Deployments, probes, and the commands `kubectl get`, `kubectl apply` and `kubectl describe`.

Your playground is a single-node `kind` cluster running Kubernetes 1.35.

| Namespace | What is in it |
| --- | --- |
| `starfleet` | `scout`, a `podinfo` web application whose readiness probe has a mistake, and `shuttle`, a pod with `curl` |

`kubectl` points at the cluster as the cluster administrator.

Launch your playground now, and keep it running next to you while you read the parts:

<!-- astrona:playground -->
