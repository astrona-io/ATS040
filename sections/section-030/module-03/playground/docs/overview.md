# CNCF Structure And Kubernetes Governance Playground

A single-node kind cluster (Kubernetes 1.35). Nothing is graded.

## What is in the box

| Object | Namespace | Purpose |
| --- | --- | --- |
| Deployment and Service `scout` | `starfleet` | A web application |
| Deployment `shuttle` | `starfleet` | A pod with `curl` |

## Practice tasks

1. Run `kubectl version` and `kubectl version -o json | jq -r .serverVersion.gitVersion`.
2. List the images in `kube-system` and name the CNCF project behind each one.
3. Read feature gates with `kubectl get --raw /metrics | grep -m 5 '^kubernetes_feature_enabled'`.
4. Create a ConfigMap with the facts of the release cycle and read it back.
5. Annotate `scout` with an owner group and a contact channel.
6. Work out from the minor version which three minor versions are maintained today.
