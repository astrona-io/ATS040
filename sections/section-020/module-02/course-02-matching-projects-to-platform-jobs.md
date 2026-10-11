---
draft: true
exam_objectives:
  - Cloud Native Ecosystem and Principles
---
# Matching Projects To Platform Jobs

The platform needs orchestration, runtime execution, delivery and observability. The Cloud Native Computing Foundation (CNCF) hosts projects in many of these areas. Learn representative tools by the job they perform rather than memorizing an unconnected list of names.

Kubernetes orchestrates workloads through its API and controllers. Containerd provides container runtime services. Cilium provides networking and security capabilities, with supported behavior depending on installation and configuration. Envoy is a proxy that can serve as a traffic component within larger systems. These projects occupy different layers even when they appear together in one platform.

Argo CD and Flux support GitOps-style delivery and reconciliation. Helm packages and manages application releases through charts. Prometheus provides metrics monitoring capabilities. OpenTelemetry supplies instrumentation and telemetry collection components. Jaeger supports distributed tracing analysis. A platform can combine several of these rather than requiring one product to replace all the others.

The right selection depends on requirements. If the need is to retain and query numerical service measurements, start with a metrics system. If the need is to collect traces and move them between systems, instrumentation and collection are relevant. If the need is to reconcile desired Kubernetes resources from versioned sources, evaluate delivery controllers.

Project maturity and popularity are evidence about adoption and governance, not a guarantee of workload suitability. Check feature support, integration contracts, resource consumption, licensing and the team's operating skills. A mature project can still lack a required feature or exceed available capacity.

Explain each component's input, output and responsibility. A clear tool choice should say which requirement it meets and what other components remain necessary. That reasoning transfers when the ecosystem introduces new projects or changes implementation details.

## Assigning Tools To A Concrete Requirement

Suppose the platform needs to run images, restore desired workload state from Git, collect request traces and retain numerical reliability measurements. A container runtime addresses execution. A delivery controller addresses configuration reconciliation. OpenTelemetry components can address instrumentation and collection. A metrics backend such as Prometheus addresses numerical monitoring. Several components are needed because the requirements occupy different boundaries.

A proxy such as Envoy can participate in traffic handling, but it does not become a complete delivery or telemetry platform merely because other systems use it. A network implementation such as Cilium can provide important connectivity and policy capabilities, but those must be matched to supported installation and operating requirements. Products can include integrations without losing their primary responsibilities.

Ask what enters a component, what it produces and what state it owns. A runtime consumes image references and execution requests. A GitOps controller consumes declared configuration and changes live resources. A collector receives telemetry and exports it. These input-output contracts make role comparisons more meaningful than memorizing names.

## Operating Suitability And Community Evidence

Evaluate release stability, compatibility, resource use, documentation and the support model. A highly adopted project can still be too complex for a small team or lack one required capability. A less mature project can be appropriate for experimentation while unsuitable for a critical dependency without additional controls.

Foundation maturity, contributor activity and governance provide evidence about sustainability. They do not establish performance under the team's exact workload or guarantee absence of defects. Validate real requirements before selection and keep the decision reviewable as the ecosystem evolves.

The useful associate-level skill is to match a platform job to a component category and explain its limits. A correct tool choice should identify what remains outside that tool, including data ownership, application correctness and other necessary integrations.

## Common pitfalls

> [!WARNING]
> A collector, metrics backend, proxy and delivery controller are different components. Foundation membership or project maturity does not guarantee that a tool fits every requirement.
