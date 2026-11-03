---
draft: true
exam_objectives:
  - Cloud Native Ecosystem and Principles
---
# Summary

Cloud native work involves several roles. Developers write and often run services. DevOps engineers automate build and release. Platform engineers build the shared platform. Site reliability engineers keep services reliable with measurable targets. Security engineers build security into the pipeline and platform. Cloud architects design the system, cluster administrators operate Kubernetes and FinOps practitioners manage cost. One person can hold several roles.

Platform engineering builds an internal developer platform with self-service, golden paths, observability and guardrails, and treats it as a product for developers. Team Topologies names stream-aligned, platform, enabling and complicated-subsystem teams, and the aim of a platform team is to reduce the cognitive load of the others.

In a cluster, a persona maps to permissions with RBAC. A Role and a RoleBinding work in one namespace, and a ClusterRole and a ClusterRoleBinding work cluster-wide. RBAC only allows, so least privilege means to grant the minimum rules. `kubectl auth can-i --as` tests the access of a subject.

DevOps is a culture of automation, continuous delivery and fast feedback, measured by the DORA metrics. SRE adds service level indicators, objectives, agreements, error budgets, toil reduction and blameless postmortems.

- A role is a responsibility, not a job title.
- A platform is a product with self-service and golden paths.
- RBAC has no deny rule. Grant the minimum.
- An SLO sets the error budget that decides the pace of change.

<!-- astrona:playground:destroy -->
