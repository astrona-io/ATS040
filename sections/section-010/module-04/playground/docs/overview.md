# Cloud Cost Management Playground

A single-node kind cluster (Kubernetes 1.35) with Metrics Server installed. Nothing is graded.

## What is in the box

| Object | Namespace | Purpose |
| --- | --- | --- |
| Metrics Server | `kube-system` | Serves `metrics.k8s.io`, so `kubectl top` works |
| Deployment and Service `scout` | `starfleet` | A web application that requests 500m CPU and 256Mi memory |
| Deployment `shuttle` | `starfleet` | A pod with `curl` that can send load |

Metrics Server needs about a minute after the cluster starts before it returns values.

## Practice tasks

1. Run `kubectl top pod -n starfleet` and compare the CPU and memory columns with the requests of `scout`.
2. Add the labels `team=bridge` and `cost-center=exploration` to the namespace with `kubectl label namespace starfleet`.
3. Apply a ResourceQuota with `requests.cpu: "1"` and try to scale `scout` to 3 replicas. Read the events of the ReplicaSet to find the `forbidden` reason.
4. Apply a LimitRange with a default request, then create a pod without resources and read the request it received.
5. Lower the requests of `scout` with `kubectl set resources` and run `kubectl describe resourcequota` to see the used values fall.
