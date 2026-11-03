---
draft: true
exam_objectives:
  - Cloud Native Observability
---
# Kubernetes Built-In Observability

Before a team installs any monitoring stack, Kubernetes already gives information about its objects. This part lists those built-in sources, what each one tells you and where each one stops. The Kubernetes and Cloud Native Associate (KCNA) exam expects you to know which tool answers which question.

## Logs from the container runtime

The container runtime captures what a process writes to standard output and standard error, and the kubelet keeps it on the node. `kubectl logs` reads it through the API server. The log is tied to the container, so a pod that is deleted takes its log with it, and the kubelet rotates old files by size. A cluster that needs history must ship logs to a central store.

Useful options: `--tail=N` for the last lines, `--since=10m` for a time window, `--previous` for the log of the last terminated container after a restart, and `-c NAME` to choose a container in a pod with several.

## Events

Kubernetes components record **events** for things that happen to an object: a pod was scheduled, an image was pulled, a probe failed, a container was killed. Events explain why an object is in its present state. They are stored in the API for a short time, by default one hour, and are not a long-term audit record.

## Object status and conditions

Every object has a `status` that controllers update. A pod has a phase and conditions such as `Ready`, `ContainersReady` and `PodScheduled`. A Deployment has conditions such as `Available` and `Progressing`. `kubectl describe` prints the status and the related events together.

## Health probes

Probes are checks that the kubelet runs against a container. A **liveness probe** restarts the container when it fails. A **readiness probe** removes the pod from Service endpoints when it fails. A **startup probe** holds the other probes back until a slow start has finished. Probe results are visible as events and in the restart count.

## Resource metrics

The **Metrics Server** is an add-on that collects CPU and memory usage from the kubelets and serves it through the Metrics API. `kubectl top` and the Horizontal Pod Autoscaler read from it. It holds only recent values and no history, so it is not a monitoring system.

## Cluster state metrics and the Prometheus endpoints

The Kubernetes components expose their own metrics in the Prometheus format on `/metrics`. **kube-state-metrics** is a separate add-on that turns the state of API objects into metrics, for example the number of desired and available replicas of a Deployment. Prometheus scrapes both, so a team can alert on a Deployment that has fewer ready pods than desired.

## Audit logs

The API server can write an **audit log** of requests: who did what, to which object and when. It answers security questions and is configured by an audit policy on the control plane.

## Which tool answers which question

| Question | First tool |
| --- | --- |
| What did the application print? | `kubectl logs` |
| Why is this pod not running? | `kubectl describe pod` and events |
| Is the Deployment healthy? | `kubectl rollout status`, conditions |
| How much CPU does it use right now? | `kubectl top` |
| How did the error rate change last week? | Prometheus, a metrics backend |
| Who deleted this object? | Audit log |

## Try the built-in sources

Read the log of the `scout` application, then the events of the namespace:

<!-- astrona:playground:renew -->

```sh
kubectl -n starfleet logs deploy/scout --tail=5
kubectl -n starfleet get events --sort-by=.lastTimestamp
```

Read the status and conditions of the Deployment:

```sh
kubectl -n starfleet get deployment scout -o jsonpath='{range .status.conditions[*]}{.type}={.status}{"\n"}{end}'
```

Each line is a condition type and its status. The built-in sources describe the present and the recent past. For a trend you need stored metrics.

## Common pitfalls

> [!WARNING]
> - **Using `kubectl logs` as a log archive.** The log goes away with the pod and is rotated on the node.
> - **Reading events as permanent.** They expire after about an hour.
> - **Treating the Metrics Server as monitoring.** It has no history and no alerting.
> - **Looking at the pod only.** The Deployment, ReplicaSet and Service often hold the cause.
