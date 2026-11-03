# Community And Collaboration - Playground

- **Slug:** ats-040-playground-030-01
- **Author:** Paris Nakita Kejser
- **Type:** Astrona playground - clean environment, no task, no grading

Sandbox with a scout Deployment that has a small mistake, used to practice recording evidence, reviewing a change with a diff and recording its reason.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS040.git -c sections/section-030/module-01/playground
astrona destroy ats-040-playground-030-01
```

`astrona destroy` takes the environment name (`metadata.name`), not the config path. `astrona submit` and `astrona test` do not apply: there is no grading.

Status: UNTESTED. Written and statically checked only.

## Layout

| Path | Purpose |
| --- | --- |
| `config.yaml` | Environment definition |
| `manifests/` | Starting objects |
| `docs/overview.md` | What the environment contains and ideas to try |
