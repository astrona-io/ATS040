# Cloud Cost Management - Playground

- **Slug:** ats-040-playground-010-04
- **Author:** Paris Nakita Kejser
- **Type:** Astrona playground - clean environment, no task, no grading

Sandbox with Metrics Server and a scout application that requests far more CPU and memory than it uses, for practice with quota, defaults and right-sizing.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS040.git -c sections/section-010/module-04/playground
astrona destroy ats-040-playground-010-04
```

`astrona destroy` takes the environment name (`metadata.name`), not the config path. `astrona submit` and `astrona test` do not apply: there is no grading.

Status: UNTESTED. Written and statically checked only.

## Layout

| Path | Purpose |
| --- | --- |
| `config.yaml` | Environment definition |
| `manifests/` | Starting objects |
| `docs/overview.md` | What the environment contains and ideas to try |
