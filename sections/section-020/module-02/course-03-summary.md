---
draft: true
exam_objectives:
  - Cloud Native Ecosystem and Principles
---
# Summary

Kubernetes reaches other software through open interfaces. The Open Container Initiative defines the image format, the runtime behavior and the way images are distributed. The Container Runtime Interface lets the kubelet start containers through any compatible runtime, such as containerd or CRI-O, and the runtime calls an OCI runtime such as runc. The Container Network Interface lets a plugin give each pod an address and routes. The Container Storage Interface lets a driver create and attach volumes. Open standards give interoperability: a replacement that follows the same interface does not force a change in the layers above.

A specification is a written contract. An implementation is software that follows the contract. A managed service is an implementation that a provider operates for a customer. Choosing an implementation means choosing who runs it, which features it adds beyond the specification and how hard it is to leave. A managed service moves operating work to the provider and can add provider-specific behavior.

The ecosystem groups projects by the platform job they do: container runtime, networking, storage, observability, delivery, service mesh, policy, packaging and others. A good choice starts from a requirement and a constraint, for example the team size, the existing tools and the support the organization can offer. The names of projects change over time, and a project's maturity level is a separate fact from its fit.

Many projects extend Kubernetes through a CustomResourceDefinition. The definition adds a new resource kind to the API server, with a schema that the API server uses to validate every object of that kind. A controller reads those objects and works until the real system matches them. The combination is the operator pattern.

- The kubelet talks to the runtime through CRI, not to a specific product.
- A custom resource is stored by the API server and acts only when a controller reads it.
- A schema in the CustomResourceDefinition rejects invalid objects at the API server.
- Compare options by requirement and constraint, not by popularity.

<!-- astrona:playground:destroy -->
