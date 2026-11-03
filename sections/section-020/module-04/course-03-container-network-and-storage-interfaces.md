---
draft: true
exam_objectives:
  - Cloud Native Ecosystem and Principles
---
# The Container Network And Storage Interfaces

A pod needs an IP address that other pods can reach, and many pods need a disk that outlives them. Kubernetes does not implement either. It defines two interfaces and delegates the work to plugins. This part explains the Container Network Interface (CNI) and the Container Storage Interface (CSI), what each plugin does, and how a storage request becomes a volume.

## The Container Network Interface

The **Container Network Interface (CNI)** is a CNCF specification for configuring the network of a Linux container. It is small. A CNI plugin is an executable that the runtime calls with a command and a JSON configuration. The main commands are `ADD`, which connects a container to the network, `DEL`, which removes it, and `CHECK`, which verifies it. Plugin binaries are normally in `/opt/cni/bin` on the node and their configuration is in `/etc/cni/net.d`.

When a pod starts, the runtime creates the pod sandbox and its network namespace, then calls the CNI plugin with `ADD`. The plugin creates a virtual network interface in the namespace, assigns an IP address from the pod range of the node, and sets up the routes. When the pod is deleted, the runtime calls `DEL`, and the plugin releases the address.

Kubernetes sets the rules that every CNI plugin must meet:

- Every pod gets its own IP address.
- Pods can reach all other pods in the cluster without Network Address Translation (NAT).
- Agents on a node can reach all pods on that node.

How the plugin meets the rules differs. Flannel builds a simple overlay network. Calico uses routing, and optionally eBPF, and enforces network policy. Cilium uses eBPF for networking, policy and observability. Cloud providers also ship plugins that give pods addresses from the virtual network of the cloud. `kind` uses a simple plugin called kindnet.

A CNI plugin also decides whether a `NetworkPolicy` works. The NetworkPolicy API is part of Kubernetes, but the enforcement is done by the plugin. A plugin that does not enforce policy accepts the object and ignores it.

## The Container Storage Interface

The **Container Storage Interface (CSI)** is a specification for exposing storage systems to container orchestrators. Before CSI, storage drivers were compiled into the Kubernetes code (in-tree). Adding a driver meant a change in Kubernetes. With CSI, a vendor ships a separate driver that runs in the cluster, and Kubernetes talks to it through gRPC. The in-tree drivers have been migrated to CSI.

A CSI driver has two parts:

- A **controller plugin**, usually a Deployment, creates and deletes volumes, attaches them to nodes, takes snapshots and resizes volumes in the storage system.
- A **node plugin**, a DaemonSet, runs on each node and formats and mounts the volume into the pod's directory.

Kubernetes provides sidecar containers, such as `external-provisioner`, `external-attacher`, `external-resizer` and `external-snapshotter`, that watch Kubernetes objects and call the driver. The driver author writes only the storage logic. Examples are the drivers for AWS EBS, Google Persistent Disk, Azure Disk, Ceph (through Rook) and many more.

## From claim to volume

Three objects connect an application to storage.

| Object | Role |
| --- | --- |
| PersistentVolumeClaim (PVC) | A request for storage by a user: a size, an access mode and a StorageClass |
| PersistentVolume (PV) | A piece of storage in the cluster, created by an administrator or by a provisioner |
| StorageClass | A template that names the provisioner (the CSI driver) and its parameters |

With **dynamic provisioning**, a user creates only the claim. The provisioner named by the StorageClass creates the volume and a PersistentVolume, and Kubernetes binds them. The StorageClass field `volumeBindingMode` chooses when this happens. `Immediate` creates the volume at once. `WaitForFirstConsumer` waits until a pod uses the claim, so the volume is created in the zone where the pod runs.

```mermaid
flowchart LR
    A["PVC"] --> B["StorageClass"]
    B --> C["CSI driver provisions"]
    C --> D["PV bound to PVC"]
    D --> E["Pod mounts volume"]
```

The diagram shows the path from the claim to the mount. The `reclaimPolicy` of the class decides what happens when the claim is deleted: `Delete` removes the volume and `Retain` keeps it.

## Look at storage in the playground

<!-- astrona:playground:renew -->

List the StorageClasses of the cluster:

```sh
kubectl get storageclass
```

The `kind` cluster has a class named `standard` and marks it as the default. Its provisioner is a local path provisioner from Rancher and not a CSI driver of a cloud, which is enough to practice the objects. In the output, read the `PROVISIONER`, `RECLAIMPOLICY` and `VOLUMEBINDINGMODE` columns.

Save this claim as `pvc-logbook.yaml`:

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: logbook
  namespace: starfleet
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: standard
  resources:
    requests:
      storage: 100Mi
```

Apply it and check the status:

```sh
kubectl apply -f pvc-logbook.yaml
kubectl -n starfleet get pvc logbook
```

If the class uses `WaitForFirstConsumer`, the claim stays in `Pending` until a pod uses it. That is normal. The event says `waiting for first consumer to be created before binding`. Delete the claim after the exercise with `kubectl -n starfleet delete pvc logbook`.

## Summing up and what is still open

CNI plugins give pods IP addresses and routes, and their quality decides whether network policy is enforced. CSI drivers create, attach and mount volumes for claims, and the StorageClass links a claim to a driver. These two interfaces and the runtime interface are the plug-in points of a node. Other standards cover what runs on top: meshes, events and telemetry.

## Common pitfalls

> [!WARNING]
> - **Assuming a NetworkPolicy always works.** If the CNI plugin does not enforce policy, the object has no effect.
> - **Calling the CSI driver a Kubernetes component.** It is installed by the storage vendor or the cloud provider.
> - **A claim that stays Pending and a search for an error.** With `WaitForFirstConsumer` that is the expected state until a pod uses the claim.
> - **Forgetting the reclaim policy.** `Delete` removes the data with the claim, and `Retain` keeps a disk that is still billed.
