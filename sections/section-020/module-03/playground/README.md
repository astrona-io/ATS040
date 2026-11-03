# Autoscaling - Playground

- **Slug:** ats-040-playground-020-03
- **Author:** Paris Nakita Kejser
- **Type:** Astrona playground - clean environment, no task, no grading

Sandbox with Metrics Server, the scout application with a CPU request and a shuttle curl pod, used to create and tune a HorizontalPodAutoscaler.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS040.git -c sections/section-020/module-03/playground
astrona destroy ats-040-playground-020-03
```

`astrona destroy` takes the environment name (`metadata.name`), not the config path. `astrona submit` and `astrona test` do not apply: there is no grading.

Status: UNTESTED. Written and statically checked only.

## Layout

| Path | Purpose |
| --- | --- |
| `config.yaml` | Environment definition |
| `manifests/` | Starting objects |
| `docs/overview.md` | What the environment contains and ideas to try |
