# Open Standards And Interfaces - Playground

- **Slug:** ats-040-playground-020-04
- **Author:** Paris Nakita Kejser
- **Type:** Astrona playground - clean environment, no task, no grading

Sandbox with the scout application and a shuttle curl pod on a kind node that uses containerd and the standard StorageClass, for practice with RuntimeClass and PersistentVolumeClaim objects.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS040.git -c sections/section-020/module-04/playground
astrona destroy ats-040-playground-020-04
```

`astrona destroy` takes the environment name (`metadata.name`), not the config path. `astrona submit` and `astrona test` do not apply: there is no grading.

Status: UNTESTED. Written and statically checked only.

## Layout

| Path | Purpose |
| --- | --- |
| `config.yaml` | Environment definition |
| `manifests/` | Starting objects |
| `docs/overview.md` | What the environment contains and ideas to try |
