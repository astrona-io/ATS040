---
draft: true
exam_objectives:
  - Cloud Native Ecosystem and Principles
---
# Open Standards And Interfaces

Kubernetes does not build a container runtime, a network plugin or a storage driver. It defines interfaces and lets many projects provide the implementations. This design lets a cluster use containerd or CRI-O, Calico or Cilium, and a local disk or a cloud volume, without a change in Kubernetes itself. The interfaces are open standards, and the Kubernetes and Cloud Native Associate (KCNA) exam asks you to name them and say what each one does.

This module explains the open standards of the cloud native ecosystem. It starts with the Open Container Initiative (OCI) specifications for images and runtimes. It then covers the Kubernetes plug-in interfaces: the Container Runtime Interface (CRI), the Container Network Interface (CNI) and the Container Storage Interface (CSI), and the interfaces for service meshes and events. In the playground you find where these interfaces appear in a running cluster.

The module has four deep-dive parts. The first part covers why standards matter and the OCI image and runtime specifications. The second part covers the CRI and runtime classes. The third part covers the CNI and the CSI. The fourth part covers the mesh, event and telemetry standards. A graded lab after the third part asks you to use a runtime class and a storage class.

## Learning objectives

After this module you can:

- Explain what an open standard is and why a vendor-neutral interface helps.
- Describe the OCI image specification, runtime specification and distribution specification.
- Explain the relation between the kubelet, the CRI, containerd and runc.
- Describe what a CNI plugin and a CSI driver each do.
- Name the standards for service meshes, events and telemetry.
- Create a RuntimeClass and a PersistentVolumeClaim that use a standard interface.

## Before you start

You need Kubernetes basics: Pods, PersistentVolumeClaims, and the commands `kubectl get`, `kubectl apply` and `kubectl describe`.

Your playground is a single-node `kind` cluster running Kubernetes 1.35. The node uses containerd as its runtime and the `standard` StorageClass that kind provides.

| Namespace | What is in it |
| --- | --- |
| `starfleet` | `scout`, a `podinfo` web application, and `shuttle`, a pod with `curl` |

`kubectl` points at the cluster as the cluster administrator.

Launch your playground now, and keep it running next to you while you read the parts:

<!-- astrona:playground -->
