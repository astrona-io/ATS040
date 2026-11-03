# Open Standards And Interfaces Playground

A single-node kind cluster (Kubernetes 1.35). The node runs containerd with the `runc` handler, and the `standard` StorageClass is the default. Nothing is graded.

## What is in the box

| Object | Namespace | Purpose |
| --- | --- | --- |
| Deployment and Service `scout` | `starfleet` | A web application whose image reference you can read |
| Deployment `shuttle` | `starfleet` | A pod with `curl` |
| StorageClass `standard` | cluster | The default class that kind provides |

## Practice tasks

1. Read the image of `scout` and the `imageID` of its pod, and compare the tag with the digest.
2. Run `kubectl get storageclass` and read the provisioner, the reclaim policy and the binding mode.
3. Create a RuntimeClass with the handler `runc` and a pod that uses it. Then change the handler to a name that does not exist and read the events of a new pod.
4. Create a PersistentVolumeClaim and a pod that mounts it. Write a file, delete the pod, create it again and read the file.
5. Run `kubectl api-resources | grep -i -E "runtimeclass|storageclass|csidriver"` to list the objects that belong to these interfaces.
