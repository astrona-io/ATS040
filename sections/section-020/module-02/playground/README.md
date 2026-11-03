# Cloud Native Ecosystem - Playground

- **Slug:** ats-040-playground-020-02
- **Author:** Paris Nakita Kejser
- **Type:** Astrona playground - clean environment, no task, no grading

Sandbox with the scout application and a shuttle curl pod, used to inspect the Kubernetes API and to create a custom resource type.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS040.git -c sections/section-020/module-02/playground
astrona destroy ats-040-playground-020-02
```

`astrona destroy` takes the environment name (`metadata.name`), not the config path. `astrona submit` and `astrona test` do not apply: there is no grading.

Status: UNTESTED. Written and statically checked only.

## Layout

| Path | Purpose |
| --- | --- |
| `config.yaml` | Environment definition |
| `manifests/` | Starting objects |
| `docs/overview.md` | What the environment contains and ideas to try |
