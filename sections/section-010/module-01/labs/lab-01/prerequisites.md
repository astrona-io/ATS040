# Prerequisites

- The `astrona` command-line tool, installed and working (`astrona check` passes).
- A container engine that kind can use (Podman or Docker) with about 2 GiB of free memory.
- `kubectl` and `jq`.
- You know how a Prometheus scrape job, a recording rule and an alerting rule are written, and how to apply a ConfigMap change to Prometheus.

The lab starts a single-node kind cluster (Kubernetes 1.35) with Prometheus and the Starfleet workloads. The commands for the lab are in the README of this folder.
