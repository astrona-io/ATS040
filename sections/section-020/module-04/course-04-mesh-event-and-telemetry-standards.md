---
draft: true
exam_objectives:
  - Cloud Native Ecosystem and Principles
---
# Mesh, Event And Telemetry Standards

The runtime, network and storage interfaces sit on the node. The standards in this part sit higher: how traffic is routed into and between services, how events are described and how telemetry is exposed. They follow the same pattern, a vendor-neutral interface with several implementations, and the exam asks you to name them and match them to their jobs.

## Gateway API and Ingress

Traffic from outside the cluster used to be described with the **Ingress** API. Ingress is small. It supports host and path rules for HTTP, and everything else is configured with controller-specific annotations, which breaks portability. The **Gateway API** is the newer standard from the Kubernetes SIG Network. It splits the roles into separate objects: a `GatewayClass` names a controller implementation, a `Gateway` is a load balancer instance that a platform team owns, and a `HTTPRoute` maps hosts and paths to Services and is owned by an application team. It also supports traffic splitting, header matching and other protocols. Many ingress controllers and service meshes implement it. The Ingress API is frozen and still works.

## Service mesh interfaces

A **service mesh** adds a dedicated layer for service-to-service communication: mutual TLS (mTLS), retries, timeouts and traffic metrics, usually through a sidecar proxy or a node proxy. Istio and Linkerd are the best-known CNCF meshes. The **Service Mesh Interface (SMI)** was an earlier attempt at a common API for meshes. The CNCF has archived it, and its role is now taken by the Gateway API, whose mesh work is called GAMMA. When you meet SMI in an exam, treat it as a vendor-neutral mesh API that is no longer developed.

## CloudEvents

**CloudEvents** is a CNCF graduated specification for describing event data in a common way. Without it, every producer invents its own envelope, and every consumer needs custom code for every producer. A CloudEvent has required attributes: `id`, `source`, `specversion` and `type`, and optional ones such as `time`, `subject` and `datacontenttype`. The data is carried separately. Bindings define how the event travels over HTTP, Kafka, AMQP and other protocols. In HTTP **binary mode** the attributes are headers that start with `ce-`:

```text
ce-specversion: 1.0
ce-type: com.example.order.created
ce-source: /orders/service
ce-id: 6f1c0a2e-1b1d-4f46-9a4f-2d4a1c7a1e11
content-type: application/json
```

Knative Eventing, Argo Events and the major cloud event services use CloudEvents, so a function written for one can receive events from another.

## Telemetry standards

OpenTelemetry defines the API, SDK, data model and protocol (OTLP) for traces, metrics and logs. **OpenMetrics** is a specification of the text format that Prometheus popularized, so that other systems can expose and ingest the same format. The W3C Trace Context standard defines the `traceparent` header used to follow a request across services.

## Policy, packaging and delivery

- **Open Policy Agent (OPA)** is a CNCF graduated general-purpose policy engine with its own language, Rego. Gatekeeper connects it to Kubernetes admission. **Kyverno** is a Kubernetes-native alternative with policies written in YAML.
- **Helm** is a CNCF graduated package manager that bundles Kubernetes manifests as charts.
- **Cluster API** defines Kubernetes-style objects for creating and managing clusters.
- **The Kubernetes API itself** is also a standard surface. CustomResourceDefinitions let projects add their own types, and tools such as Argo CD and Flux read them.

## Choosing and judging a standard

A useful check, when you look at a technology, is to ask four questions:

1. Is there a published specification, and who maintains it?
2. Are there several independent implementations?
3. Is it still maintained, or has it been archived?
4. Does your tooling depend on a vendor-specific extension?

An interface with one implementation is a product. A standard that nobody updates carries risk. The ecosystem moves, as the SMI and Ingress cases show.

## Matching standards to jobs

| Job | Standard or interface |
| --- | --- |
| Image format and registry API | OCI image and distribution specifications |
| Starting a container process | OCI runtime specification (runc, crun) |
| Kubelet to runtime | CRI (containerd, CRI-O) |
| Pod networking | CNI (Calico, Cilium, Flannel) |
| Volumes | CSI (vendor drivers) |
| North-south traffic | Gateway API, Ingress |
| Event format | CloudEvents |
| Telemetry | OpenTelemetry, OpenMetrics, W3C Trace Context |

## Summing up

Open standards let Kubernetes run on any compliant component. Gateway API replaces annotations on Ingress with role-based objects, SMI is archived, CloudEvents standardizes the event envelope, and OpenTelemetry, OpenMetrics and Trace Context standardize telemetry. When you judge a technology, look for a specification, several implementations and an active maintainer.

## Common pitfalls

> [!WARNING]
> - **Treating Ingress as removed.** It is frozen and still works. New designs prefer the Gateway API.
> - **Assuming SMI is the current mesh API.** It is archived.
> - **Mixing up CloudEvents and OpenTelemetry.** One describes business events, the other describes telemetry.
> - **Equating a standard with one product.** A specification can have many implementations.
