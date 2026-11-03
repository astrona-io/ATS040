# Question

Solve this question on: `terminal`

The `scout` Deployment in `starfleet` runs one replica. It has no health probes and no resource requests, and its message `PODINFO_UI_MESSAGE` is written directly in the pod template. The `drifter` in `outpost` must keep reaching `scout`, even when a pod fails or a node is drained. Make `scout` resilient.

1. Run three replicas of `scout`. All three must be available.

2. Add a readiness probe that sends an HTTP GET to `/readyz` and a liveness probe that sends an HTTP GET to `/healthz`, both on the container port.

3. Give the `scout` container a CPU request and a memory request.

4. Move `PODINFO_UI_MESSAGE` out of the pod template. Create a ConfigMap named `scout-config` with that key and make the container read it.

5. Create a PodDisruptionBudget for the pods labelled `app: scout` that keeps at least two pods available.

`scout` must keep answering requests from `shuttle`. Do not delete the Deployment or the Service. `kubectl` already points at the cluster as the cluster administrator.
