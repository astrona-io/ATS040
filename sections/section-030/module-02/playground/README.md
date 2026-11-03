# API Maturity And Deprecation - Playground

- **Slug:** ats-040-playground-030-02
- **Author:** Paris Nakita Kejser
- **Type:** Astrona playground - clean environment, no task, no grading

Sandbox for listing served API versions, trying a manifest with a removed version and migrating it.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS040.git -c sections/section-030/module-02/playground
astrona destroy ats-040-playground-030-02
```

`astrona destroy` takes the environment name (`metadata.name`), not the config path. `astrona submit` and `astrona test` do not apply: there is no grading.

Status: UNTESTED. Written and statically checked only.

## Layout

| Path | Purpose |
| --- | --- |
| `config.yaml` | Environment definition |
| `manifests/` | Starting objects |
| `docs/overview.md` | What the environment contains and ideas to try |
