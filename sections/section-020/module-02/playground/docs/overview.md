# Cloud Native Ecosystem Playground

A single-node kind cluster (Kubernetes 1.35) for looking at the standard interfaces and extension points of Kubernetes. Nothing is graded.

## What is in the box

| Object | Namespace | Purpose |
| --- | --- | --- |
| Deployment and Service `scout` | `starfleet` | A web application to inspect |
| Deployment `shuttle` | `starfleet` | A pod with `curl` for requests from inside the cluster |

## Helper functions

Paste these into your shell to shorten the commands.

```sh
node_runtime() { kubectl get nodes -o jsonpath='{.items[0].status.nodeInfo.containerRuntimeVersion}{"\n"}'; }
api_kinds() { kubectl api-resources --api-group="$1"; }
pod_cni() { kubectl -n kube-system get pods -o wide; }
```

## Practice tasks

1. Run `node_runtime` and name the container runtime and its version.
2. List the storage classes with `kubectl get storageclass` and read the provisioner name.
3. List the built-in API groups with `kubectl api-versions`.
4. Create a CustomResourceDefinition for a `Sensor` kind in the group `fleet.example.com`, then create one object of that kind.
5. Send an invalid `Sensor` with `kubectl create --dry-run=server` and read the error from the API server.
6. Delete the CustomResourceDefinition and check what happens to the `Sensor` objects.
