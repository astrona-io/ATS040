---
estimated_duration: 20m
---

# Lab: Configure Telemetry For A Workload

Graded lab for the OpenTelemetry module. The learner sets the standard OpenTelemetry variables on the scout Deployment and writes a Collector configuration into a ConfigMap. The task is in `question.md`; the walkthrough is in `solution.md`.

Status: UNTESTED. Written and statically checked only. The validation scripts and the reference solution have not been run.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS040.git -c sections/section-010/module-02/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS040.git -c sections/section-010/module-02/labs/lab-01
astrona destroy ats-040-lab-010-02
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-service-name.sh` | OTEL_SERVICE_NAME is scout |
| `validate-exporter.sh` | The exporter endpoint is http://collector.starfleet:4318 with protocol http/protobuf |
| `validate-sampler.sh` | The sampler is parentbased_traceidratio with argument 0.25 |
| `validate-receiver.sh` | ConfigMap collector-config defines an otlp HTTP receiver on 0.0.0.0:4318 and the processors memory_limiter and batch |
| `validate-pipelines.sh` | Pipelines traces and metrics use otlp, then memory_limiter and batch in order, then debug |
