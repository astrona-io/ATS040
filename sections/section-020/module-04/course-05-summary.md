---
draft: true
exam_objectives:
  - Cloud Native Ecosystem and Principles
---
# Summary

An open standard is a published specification that anyone can implement and a vendor-neutral group maintains. It gives portability, the choice to swap components and protection from a single vendor. A specification defines behavior, an implementation is software that follows it, and a managed service is an implementation that a provider runs.

The Open Container Initiative defines the image format, how to run a container from a bundle and the registry API. An image is a manifest, a config and layers, all addressed by digest. A tag is a movable name, so a digest is the only fixed reference. runc is the reference implementation of the runtime specification, and crun, gVisor and Kata Containers are others.

Kubernetes uses interfaces to reach components on the node. The Container Runtime Interface is the gRPC API from the kubelet to a runtime such as containerd or CRI-O, which calls an OCI runtime to start the process. A RuntimeClass lets a pod choose a runtime handler. The Container Network Interface connects pods to a network and gives each one an address, and the plugin decides whether network policy is enforced. The Container Storage Interface lets storage vendors ship drivers that a StorageClass names, so a claim becomes a volume by dynamic provisioning.

Higher-level standards cover traffic, events and telemetry. The Gateway API replaces annotation-based Ingress with role-based objects, and the Service Mesh Interface is archived. CloudEvents describes events with required attributes, OpenTelemetry and OpenMetrics describe telemetry, and W3C Trace Context carries a trace between services.

- OCI defines images, runtime and distribution.
- The kubelet speaks CRI, not Docker.
- CNI and CSI plugins do the node-level work for network and storage.
- A tag can move, a digest cannot.

<!-- astrona:playground:destroy -->
