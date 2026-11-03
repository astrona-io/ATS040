# Community And Collaboration Playground

A single-node kind cluster (Kubernetes 1.35). Nothing is graded.

## What is in the box

| Object | Namespace | Purpose |
| --- | --- | --- |
| Deployment and Service `scout` | `starfleet` | A web application whose readiness probe calls `/healthz` instead of `/readyz` |
| Deployment `shuttle` | `starfleet` | A pod with `curl` |

## Helper functions

Paste these into your shell to shorten the commands.

```sh
probe_paths() { kubectl -n starfleet get deploy "$1" -o jsonpath='readiness={.spec.template.spec.containers[0].readinessProbe.httpGet.path} liveness={.spec.template.spec.containers[0].livenessProbe.httpGet.path}{"\n"}'; }
review_change() { kubectl diff -f "$1"; echo "diff exit code: $?"; }
change_reason() { kubectl -n starfleet get deploy "$1" -o jsonpath='{.metadata.annotations.kubernetes\.io/change-cause}{"\n"}'; }
```

## Practice tasks

1. Run `probe_paths scout` and find the mistake.
2. Write a ConfigMap that records the license, contribution rules and decision for a dependency.
3. Write the corrected Deployment, run `review_change` on it and read every changed line.
4. Apply the change, record the reason with the change-cause annotation, and read it with `change_reason scout`.
5. Run `kubectl rollout history deployment/scout -n starfleet` and find the recorded reason.
