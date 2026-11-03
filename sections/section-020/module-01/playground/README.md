# Cloud Native Design - Playground

- **Slug:** ats-040-playground-020-01
- **Author:** Paris Nakita Kejser
- **Type:** Astrona playground - clean environment, no task, no grading

Single-node kind cluster (Kubernetes 1.35). `scout` runs with one replica, no probes, no resource requests and an inline environment variable; `probe` is an HTTP test server; `shuttle` and `drifter` are pods with curl.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS040.git -c sections/section-020/module-01/playground
astrona destroy ats-040-playground-020-01
```

`astrona destroy` takes the environment name (`metadata.name`), not the config path. `astrona submit` and `astrona test` do not apply: there is no grading.

Status: UNTESTED. Written and statically checked only.

## Layout

| Path | Purpose |
| --- | --- |
| `config.yaml` | Environment definition |
| `manifests/` | Starting objects |
| `docs/overview.md` | What the environment contains and ideas to try |
