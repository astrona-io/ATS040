# Question

Solve this question on: `terminal`

The `scout` application in `starfleet` will send telemetry to a Collector that the platform team runs at `http://collector.starfleet:4318`. Nothing is configured yet, and the ConfigMap `collector-config` does not exist.

1. Configure the `scout` container with the standard OpenTelemetry environment variables. The service name is `scout`. The exporter endpoint is `http://collector.starfleet:4318` and the protocol is `http/protobuf`. Use the sampler `parentbased_traceidratio` with the argument `0.25`.

2. Create a ConfigMap named `collector-config` in `starfleet` with the key `config.yaml`. The file defines an `otlp` receiver with an HTTP endpoint on `0.0.0.0:4318`, the processors `memory_limiter` and `batch`, and a `debug` exporter.

3. In the same file, define a `traces` pipeline and a `metrics` pipeline. Each pipeline uses the `otlp` receiver, the processors in the order `memory_limiter` then `batch`, and the `debug` exporter.

`kubectl` already points at the cluster as the cluster administrator.
