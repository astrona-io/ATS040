---
draft: true
exam_objectives:
  - Observability
---
# Logs In Kubernetes

Logs are the oldest signal, and they are the first thing a person reads when a pod fails. Kubernetes does not ship a log storage system. It gives each container a log stream and expects the platform team to collect it. This part explains where container logs go, what the node does with them and the three common ways to collect them.

## Where container logs go

A container in Kubernetes should write its logs to standard output (stdout) and standard error (stderr). The container runtime captures these two streams and writes them to a file on the node. For containerd, the files are under `/var/log/pods/` on the node, and the kubelet links them under `/var/log/containers/`. The file name contains the namespace, the pod name, the container name and the container ID.

The command `kubectl logs` asks the kubelet on the node to return the content of that file. That explains its limits: when the pod is deleted or the node is lost, the log file goes with it. The kubelet also rotates the files by size, with defaults of 10 MiB per file and five files per container, so old lines disappear on a busy container.

## The kubectl logs commands

<!-- astrona:playground:renew -->

Print the log of the `scout` pod through its Deployment:

```sh
kubectl -n starfleet logs deploy/scout
```

Follow the log and show only the last lines:

```sh
kubectl -n starfleet logs deploy/scout --tail=20 --follow
```

Press Ctrl-C to stop following. Other options that matter:

| Option | What it does |
| --- | --- |
| `-c <container>` | Selects a container in a pod that has several |
| `--previous` | Shows the log of the previous container instance, which is the one that crashed |
| `--since=10m` | Shows only the last ten minutes |
| `-l app=scout` | Selects pods by label |
| `--all-containers` | Shows every container of the pod |
| `--timestamps` | Adds the time to each line |

The option `--previous` is the one to use for a pod in `CrashLoopBackOff`, because the current container has just started and has nothing useful to say.

## Structured logs

A line like `user 42 failed login from 10.0.0.7` is easy to read and hard to query. A **structured log** writes each event as one JSON object with named fields:

```json
{"time":"2026-11-03T10:15:00Z","level":"error","msg":"login failed","user_id":42,"trace_id":"0af7651916cd43dd8448eb211c80319c"}
```

A collector can parse these fields, and a log back end can filter by `level` or `user_id`. Putting the trace ID in each line links the logs to the trace, so the person who reads a trace can open the exact log lines of that request.

## Three ways to collect logs

Collection means copying logs to a central place that outlives the pod. There are three patterns.

1. **Node agent.** A DaemonSet runs one log agent per node. The agent reads the files under `/var/log/pods/` through a host path mount, adds the Kubernetes metadata (namespace, pod, labels) and sends the lines on. This is the most common pattern because applications need no change. Fluent Bit, Fluentd and the OpenTelemetry Collector `filelog` receiver work this way.
2. **Sidecar.** A second container in the pod reads a log file that the application writes to a shared volume, and writes it to its own stdout or ships it. This is used when the application cannot write to stdout.
3. **Direct push.** The application sends logs to the back end with its own library. This couples the application to the back end and loses logs if the back end is down, so it is the least common.

```mermaid
flowchart LR
    A["Container stdout"] --> F["Node log file"]
    F --> G["Node agent DaemonSet"]
    G --> S["Log back end"]
```

The diagram shows the node agent path. The container does not know that its logs are collected.

## Back ends

Fluent Bit is a CNCF graduated project, written for low resource use, and it is the usual node agent. Fluentd is the older CNCF graduated project with a large plugin set. Loki is a log store from Grafana that indexes only the labels of each stream and not the full text, which makes storage cheap. Elasticsearch and OpenSearch index the full text.

## Events are not logs

Kubernetes events, such as a failed scheduling or an image pull error, are objects in the API and they expire after about one hour by default. They answer why Kubernetes did something. Application logs answer what the program did. Read events with:

```sh
kubectl -n starfleet get events --sort-by=.lastTimestamp
```

## Summing up

Containers write to stdout and stderr, the runtime stores the lines in node files and `kubectl logs` reads them from there. Those files vanish with the pod, so a node agent, a sidecar or a push from the application must copy them to a central back end. Structured logs with a trace ID make logs searchable and linked to traces. Together with metrics and traces, this completes the three signals of observability.

## Common pitfalls

> [!WARNING]
> - **Writing logs only to a file in the container.** `kubectl logs` shows nothing and the file is lost when the pod is replaced.
> - **Using `kubectl logs` for a crashed pod without `--previous`.** You read the new, empty instance.
> - **Treating `kubectl logs` as log storage.** Logs are rotated and deleted with the pod.
> - **Logging secrets.** Tokens and passwords written to a log are copied to every back end.
> - **Mixing up events and logs.** Events come from Kubernetes components and they expire.
