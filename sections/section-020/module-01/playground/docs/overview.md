# Overview: Cloud Native Design (Playground)

This is a playground, not a lab. It starts a fresh cluster with the example workloads and waits. There is no task, no `astrona submit` and no pass or fail. Change the workloads, break them, run `astrona destroy` and start over.

## What's in the box

A single-node `kind` cluster running Kubernetes 1.35. `kubectl` points at it as the cluster administrator.

| Namespace | What is in it |
| --- | --- |
| `starfleet` | `scout` (`podinfo`, one replica, no probes, no resource requests, `PODINFO_UI_MESSAGE` set inline), `probe` (`go-httpbin`, with a Service on port 80), `shuttle` (a pod with `curl`) |
| `outpost` | `drifter`, a pod with `curl` |

## Helpers

Paste these once in each new terminal. `call_scout` sends a request to the `scout` Service from the `shuttle` pod and prints the HTTP status code. `scout_endpoints` prints the pod addresses behind the Service.

```sh
call_scout() {
  kubectl -n starfleet exec deploy/shuttle -- curl -s -o /dev/null -m 3 -w '%{http_code}\n' http://scout.starfleet.svc.cluster.local/healthz
}
scout_endpoints() {
  kubectl -n starfleet get endpoints scout -o jsonpath='{.subsets[*].addresses[*].ip}'; echo
}
```

## Practice tasks

- Run `call_scout`. Delete the `scout` pod and run `call_scout` in a loop until it answers again. Note how long the gap lasts.
- Scale `scout` to three replicas and repeat the deletion. Does the gap change?
- Add a `readinessProbe` for `/readyz` and watch `scout_endpoints` while the new pod starts.
- Point a `livenessProbe` at a path that does not exist and read the pod's restart count and events.
- Create a PodDisruptionBudget for `scout` and try `kubectl drain` on the node with `--dry-run=server`.
- Create a Job that calls `http://probe.starfleet.svc.cluster.local/status/500` and watch `backoffLimit` stop it.
