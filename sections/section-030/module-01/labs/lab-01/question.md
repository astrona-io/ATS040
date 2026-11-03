# Question

Solve this question on: `terminal`

A reviewer notices that the `scout` Deployment in `starfleet` checks readiness on the same path as liveness. The application serves `/healthz` for liveness and `/readyz` for readiness. The team wants the defect reported, fixed with one focused change and recorded.

1. Write the report as a ConfigMap named `issue-report` in `starfleet`. It has the key `component` with the value `scout`, the key `observed` with a short description of the mistake, and the key `expected`, whose value states that readiness must use `/readyz`.

2. Fix the Deployment `scout`: the readiness probe must call `/readyz`.

3. Keep the change focused. The liveness probe, the container name, the image, the port and the replica count must stay as they are.

4. Record the reason on the Deployment with the annotation `kubernetes.io/change-cause`, with a text that mentions the readiness probe.

5. The rollout must finish and `scout` must have one ready replica.

`kubectl` already points at the cluster as the cluster administrator.
