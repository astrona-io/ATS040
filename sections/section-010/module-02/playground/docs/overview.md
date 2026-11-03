# OpenTelemetry, Tracing And Logs Playground

A single-node kind cluster (Kubernetes 1.35). Nothing is graded.

## What is in the box

| Object | Namespace | Purpose |
| --- | --- | --- |
| Deployment and Service `scout` | `starfleet` | A web application (`podinfo`) that writes request logs to stdout |
| Deployment `shuttle` | `starfleet` | A pod with `curl` that sends requests |
| ConfigMap `collector-config` | `starfleet` | A sample OpenTelemetry Collector configuration with one traces pipeline |

No Collector runs in the cluster. The ConfigMap is a file to read and to change.

## Practice tasks

1. Print the sample configuration with `kubectl -n starfleet get configmap collector-config -o jsonpath='{.data.config\.yaml}'` and name its receiver, processor and exporter.
2. Add a `metrics` pipeline to a copy of the file and apply it with `kubectl apply -f`.
3. Set `OTEL_SERVICE_NAME` and `OTEL_TRACES_SAMPLER` on `scout` with `kubectl set env` and list them with `--list`.
4. Send a request with a `traceparent` header from `shuttle` and read the `scout` log with `kubectl logs`.
5. Run `kubectl -n starfleet get events --sort-by=.lastTimestamp` and decide which lines are events and which are logs.
