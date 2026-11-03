---
draft: true
exam_objectives:
  - Cloud Native Ecosystem and Principles
---
# Platform Engineering And Team Topologies

As the number of tools in the cloud native landscape grew, each application team had to learn many of them. Platform engineering is the answer: a team builds a shared platform so that application teams do not have to assemble the tools themselves.

## What platform engineering is

**Platform engineering** designs and runs the tools, services and workflows that developers use to build, deploy and operate software. The result is an **internal developer platform (IDP)**: a set of self-service capabilities that cover the common needs, such as creating a service from a template, getting a namespace, deploying through a pipeline, reading logs and metrics, and managing secrets.

The platform is treated as a **product**. Its users are the developers in the company. The platform team talks to them, measures adoption and improves the platform on that feedback.

## Golden paths

A **golden path** is a supported, well-documented way to do a common task, for example to create a new web service with a pipeline, monitoring and a deployment already set up. Teams are free to leave the path, but the path is the easiest option and the platform team maintains it. This reduces the number of different setups that need support and keeps security and cost controls in place by default.

## Capabilities of a platform

- **Self-service provisioning.** A developer creates an environment without a ticket.
- **Deployment automation.** A pipeline or a GitOps controller delivers changes.
- **Observability by default.** Metrics, logs and traces are collected for every service.
- **Policy and guardrails.** Admission policies and quotas stop unsafe or costly configurations.
- **A catalog.** A list of services, owners and documentation. Backstage is a CNCF project for such a portal.

## Team Topologies

The book Team Topologies describes four types of team and three ways they work together.

| Team type | Purpose |
| --- | --- |
| Stream-aligned team | Delivers a flow of work for one business area, such as a product |
| Platform team | Provides services that make stream-aligned teams faster |
| Enabling team | Helps other teams to gain a skill, then moves on |
| Complicated-subsystem team | Owns a part that needs deep specialist knowledge |

The interaction modes are **collaboration** (two teams work closely for a time), **X-as-a-Service** (one team consumes what another provides with little contact) and **facilitation** (one team helps another to learn). A platform team aims for X-as-a-Service with its users.

The idea of **cognitive load** explains the need: a team can hold only a limited amount of knowledge. A platform takes load away from the stream-aligned teams, so they can focus on their product.

## The CNCF view

The CNCF Platforms white paper and the Platform Engineering Maturity Model describe platforms in terms of capabilities and maturity, from provisional to optimizing. The exam level only asks for the purpose: to make developers productive and reduce their cognitive load.

## Look for platform parts in a cluster

A cluster shows the effects of a platform as guardrails. Check which resource quotas and limit ranges exist in the namespace, because a platform team often sets them for each team:

<!-- astrona:playground:renew -->

```sh
kubectl -n starfleet get resourcequota,limitrange
```

The playground namespace has no quotas, which is a gap that a platform team would close by default for every new namespace.

## Common pitfalls

> [!WARNING]
> - **Building a platform without asking the users.** The result goes unused.
> - **Forcing the golden path.** It should be the easy choice, not the only choice.
> - **Calling a shared cluster a platform.** A platform has self-service, defaults and support.
> - **Measuring the platform by tool count.** Measure the time developers need to ship a change.
