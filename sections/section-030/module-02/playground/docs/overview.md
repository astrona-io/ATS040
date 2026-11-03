# API Maturity And Deprecation Playground

A single-node kind cluster (Kubernetes 1.35). Nothing is graded.

## What is in the box

| Object | Namespace | Purpose |
| --- | --- | --- |
| Deployment and Service `scout` | `starfleet` | A web application with a CPU request of 100m |
| Deployment `shuttle` | `starfleet` | A pod with `curl` |

## Helper functions

Paste these into your shell to shorten the commands.

```sh
served_versions() { kubectl api-versions | sort | grep -E "${1:-.}"; }
kind_versions() { kubectl api-resources --api-group="$1"; }
deprecated_use() { kubectl get --raw /metrics | grep apiserver_requested_deprecated_apis; }
```

## Practice tasks

1. Run `served_versions beta` and `served_versions alpha` and see which pre-release versions the cluster serves.
2. Run `kind_versions autoscaling` and `kind_versions batch` and note the versions.
3. Apply a PodDisruptionBudget with `apiVersion: policy/v1beta1` and read the error.
4. Migrate it to `policy/v1`, run a server-side dry run and a diff, then apply it.
5. Run `deprecated_use` and check whether the cluster counted a deprecated request.
