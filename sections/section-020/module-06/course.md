---
draft: true
exam_objectives:
  - Cloud Native Ecosystem and Principles
---
# Cloud Native Roles And Personas

Cloud native software is built and run by people with different roles. A developer writes the code, a platform engineer builds the tools around it, a site reliability engineer keeps it running and a security engineer protects it. The Kubernetes and Cloud Native Associate (KCNA) exam asks you to name these roles and to match a responsibility to a role.

This module explains the personas of the cloud native ecosystem. It starts with the main roles and what each one owns. It then covers platform engineering and the internal developer platform, the DevOps and site reliability engineering practices that connect the roles, and how a role maps to permissions in a cluster. In the playground you create roles that fit two personas and test what each one can do.

The module has four deep-dive parts. The first part covers the main roles. The second part covers platform engineering and team topologies. The third part covers role-based access control for personas. The fourth part covers DevOps and site reliability engineering practices. A graded lab after the third part asks you to give two personas the access that fits their role.

## Learning objectives

After this module you can:

- Name the main cloud native roles and the responsibility of each.
- Explain platform engineering and the idea of an internal developer platform.
- Describe DevOps culture and the practices of site reliability engineering, such as service level objectives and error budgets.
- Map a persona to the least access it needs with Roles and RoleBindings.
- Test the access of a user with `kubectl auth can-i --as`.

## Before you start

You need Kubernetes basics: namespaces, Pods, Deployments, and the commands `kubectl get`, `kubectl apply` and `kubectl describe`.

Your playground is a single-node `kind` cluster running Kubernetes 1.35.

| Namespace | What is in it |
| --- | --- |
| `starfleet` | `scout`, a `podinfo` web application, and `shuttle`, a pod with `curl` |

`kubectl` points at the cluster as the cluster administrator, which can act as any user.

Launch your playground now, and keep it running next to you while you read the parts:

<!-- astrona:playground -->
