---
draft: true
exam_objectives:
  - Observability
---
# Summary

OpenTelemetry is the CNCF project that standardizes how telemetry is produced and moved. It separates a small API that code calls from an SDK that decides how to sample, batch and export. It defines the OpenTelemetry Protocol (OTLP) for metrics, traces and logs, and a set of standard environment variables that configure any SDK, such as the service name, the exporter endpoint and the sampler. It does not store telemetry or draw dashboards.

The Collector sits between applications and back ends. Receivers take data in, processors change it, exporters send it out, and pipelines connect them for each signal. A component that no pipeline lists is inactive. Collectors run as agents close to the workload and as gateways that do central work such as tail sampling.

A trace is a tree of spans that share a trace ID. Services keep the trace together by passing the `traceparent` header, and a service that drops it splits the trace. Head sampling decides at the start and is cheap. Tail sampling decides at the end and can keep slow and failed requests.

Container logs go to stdout and stderr, the runtime stores them in node files, and `kubectl logs` reads those files. They are lost with the pod, so a node agent, a sidecar or a direct push must copy them to a back end. Structured logs that carry the trace ID link a log line to its trace.

- The default OTLP ports are 4317 for gRPC and 4318 for HTTP.
- `service.name` is the most important resource attribute.
- Use `kubectl logs --previous` for a container that crashed.
- Events and logs are different data with different lifetimes.

<!-- astrona:playground:destroy -->
