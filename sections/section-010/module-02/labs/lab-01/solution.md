# Solution

Solve this lab on `terminal`. Each step ends with `astrona submit`, which grades the current state.

Start the lab if it is not running:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS040.git -c sections/section-010/module-02/labs/lab-01
```

## Step 1: Set the variables on scout

```sh
kubectl -n starfleet set env deployment/scout OTEL_SERVICE_NAME=scout OTEL_EXPORTER_OTLP_ENDPOINT=http://collector.starfleet:4318 OTEL_EXPORTER_OTLP_PROTOCOL=http/protobuf OTEL_TRACES_SAMPLER=parentbased_traceidratio OTEL_TRACES_SAMPLER_ARG=0.25
kubectl -n starfleet rollout status deployment/scout --timeout=180s
```

`kubectl set env` changes the pod template and starts a new pod. List the result with `kubectl -n starfleet set env deployment/scout --list`.

## Step 2: Write the Collector configuration

Save this as `collector-config.yaml`:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: collector-config
  namespace: starfleet
data:
  config.yaml: |
    receivers:
      otlp:
        protocols:
          http:
            endpoint: 0.0.0.0:4318
    processors:
      memory_limiter:
        check_interval: 1s
        limit_mib: 200
      batch: {}
    exporters:
      debug:
        verbosity: basic
    service:
      pipelines:
        traces:
          receivers: [otlp]
          processors: [memory_limiter, batch]
          exporters: [debug]
        metrics:
          receivers: [otlp]
          processors: [memory_limiter, batch]
          exporters: [debug]
```

Apply it:

```sh
kubectl apply -f collector-config.yaml
```

## Grade

```sh
astrona submit --git ssh://git@github.com/astrona-io/ATS040.git -c sections/section-010/module-02/labs/lab-01
```

All checks pass when the five variables are set, the receiver is on port 4318, the processors are listed in order and both pipelines exist.
