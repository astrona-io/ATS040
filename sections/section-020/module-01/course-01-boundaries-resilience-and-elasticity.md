---
draft: true
exam_objectives:
  - Cloud Native Ecosystem and Principles
---
# Boundaries, Resilience And Elasticity

The `scout` application separates request handling from report generation. Cloud native design uses practices that support operation in dynamic infrastructure, including automation, loosely coupled components and observable behavior. Running an unchanged application in a container does not automatically give it those properties.

A microservice is a service organized around a focused capability with an explicit interface and independent lifecycle. An application programming interface (API) defines how callers interact with it. Loose coupling reduces the need for coordinated internal changes, but remote calls introduce latency, partial failures and compatibility requirements.

A modular monolith can still be a suitable design for a team or workload. Splitting every function into a network service can increase operating complexity without a useful benefit. Choose service boundaries from ownership, change rate, scaling and data requirements rather than treating microservice count as a quality score.

Resilience is the ability to continue useful operation or recover under failures. Timeouts bound waiting, controlled retries can recover transient failures, and circuit breakers can stop repeated calls to a failing dependency. Unbounded retries can amplify overload. Safe repeated operations need idempotency or an equivalent application mechanism.

Elasticity means adjusting capacity as demand changes. Stateless request handlers keep durable state outside a particular instance, which can make replacement and scaling easier. They are not applications with no state at all; a database, object store or other service still owns important state and has its own capacity limits.

Design for partial failure. One slow dependency should not consume every worker indefinitely, and adding replicas should not overload a fixed-capacity data service. Observable outcomes and automated recovery help, but each mechanism needs a defined purpose and realistic resource constraints.

## Comparing Service Boundaries In One Application

A reporting application has request handling, report generation and durable report storage. Separating the long-running report worker can make sense because it has different execution duration and scaling needs from the web handler. Separating every internal calculation into another remote service may add latency and failures without an ownership or capacity benefit.

A service interface needs defined inputs, outputs, errors and compatibility behavior. If clients must change whenever the provider refactors its internal code, the boundary is not loosely coupled in practice. Versioned contracts and gradual compatibility changes reduce forced coordinated releases.

Partial failure is a normal distributed condition. The report worker can fail while the web handler remains alive; the network can time out even when the database completed a write. Application behavior must distinguish a known failure from an uncertain result. Safe retries and durable progress records are responses to that uncertainty.

## Resilience And Capacity Tradeoffs

A timeout bounds resource occupancy but must fit expected operation duration. A value too short can reject normal work, while a very long value can tie up every worker during an outage. Retries improve some transient failures but consume more dependency capacity. A circuit breaker can temporarily stop calls to an unhealthy dependency, giving the system a bounded failure mode.

Elasticity also has limits. More stateless handlers can absorb parallel requests only when their dependencies and dispatch mechanism support the increased load. A fixed database, shared lock or serial operation can remain the bottleneck. Measure the limiting component before assuming replica count is the complete capacity plan.

Cloud native design therefore combines explicit boundaries, failure handling and observable outcomes. Containers and orchestration provide mechanisms for replacement and scaling, but application contracts determine whether those actions preserve correctness. A suitable architecture fits the team's capabilities and workload rather than a required count of services.

## Common pitfalls

> [!WARNING]
> Containers do not automatically create resilient architecture. Stateless handlers still use stateful dependencies, and excessive retries can worsen an outage.
