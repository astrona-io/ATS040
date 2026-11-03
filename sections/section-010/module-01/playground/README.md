# Observability And Reliability - Playground

- **ID:** PLAYGROUND
- **Slug:** ats-040-playground-010-01
- **Author:** Paris Nakita Kejser
- **Type:** Astrona playground - clean environment, no task, no grading

A single-node kind cluster (Kubernetes 1.35, `kindest/node:v1.35.8`). Prometheus
v3.5.0 runs in `monitoring` and scrapes only itself. `scout` and `probe`
(podinfo) run in `starfleet`, and `shuttle` sends a steady stream of requests to
`scout`, about one in ten of them to `/status/500`. Nothing to submit.

## Run it

```sh
astrona run -c .
astrona destroy ats-040-playground-010-01
```

## Layout

| Path | Purpose |
| --- | --- |
| `config.yaml` | Environment definition (runtime, preloaded images, starting manifests) |
| `manifests/monitoring.yaml` | Prometheus, its two ConfigMaps and the Service |
| `manifests/starfleet.yaml` | `scout`, `probe` and `shuttle` |
| `docs/overview.md` | What the environment contains and ideas to try |
