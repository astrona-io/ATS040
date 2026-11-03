# Autoscaling Playground

A single-node kind cluster (Kubernetes 1.35) with Metrics Server installed. Nothing is graded.

## What is in the box

| Object | Namespace | Purpose |
| --- | --- | --- |
| Metrics Server | `kube-system` | Serves `metrics.k8s.io`, so `kubectl top` and the HPA work |
| Deployment and Service `scout` | `starfleet` | A web application with a CPU request of 100m |
| Deployment `shuttle` | `starfleet` | A pod with `curl` that can send load |

Metrics Server needs about a minute after the cluster starts before it returns values.

## Helper functions

Paste these into your shell to shorten the commands.

```sh
hpa_state() { kubectl -n starfleet get hpa "$1" -o wide; }
hpa_conditions() { kubectl -n starfleet get hpa "$1" -o jsonpath='{range .status.conditions[*]}{.type}={.status} {.reason}{"\n"}{end}'; }
send_load() { kubectl -n starfleet exec deploy/shuttle -- sh -c "for i in \$(seq 1 ${1:-2000}); do curl -s http://scout/ >/dev/null; done"; }
```

## Practice tasks

1. Run `kubectl top nodes` and `kubectl top pods -n starfleet` and compare usage with the request of `scout`.
2. Create an HPA for `scout` with a CPU target of 50 percent, minimum 1 and maximum 4, and read its conditions with `hpa_conditions scout`.
3. Run `send_load` and watch `kubectl -n starfleet get hpa scout --watch`.
4. Add a `behavior` section with a 120 second scale-down window.
5. Remove the CPU request from `scout` with `kubectl -n starfleet set resources deploy/scout --requests=cpu=0`, then read the HPA conditions again. Note which condition changes.
