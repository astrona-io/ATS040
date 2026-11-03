# Question

Solve this question on: `terminal`

Two people join the `bridge` team. Give each of them the access that fits their role in the namespace `starfleet`, and no more.

1. Create a Role named `developer` in `starfleet`. It may `get`, `list` and `watch` Pods, `get` the sub-resource `pods/log`, and `get`, `list`, `watch`, `create`, `update` and `patch` Deployments. It may not delete anything.

2. Create a Role named `auditor` in `starfleet`. It may `get`, `list` and `watch` Pods, Services, ConfigMaps and Deployments, and nothing else.

3. Bind `developer` to the user `riker` with a RoleBinding named `developer-riker`. Bind `auditor` to the user `data` with a RoleBinding named `auditor-data`. Both bindings are in `starfleet`.

4. `riker` must be able to create Deployments in `starfleet` but not delete them and not read Secrets. `data` must be able to read Pods but not create Deployments and not read Secrets. Neither may do anything in the namespace `default`.

`kubectl` already points at the cluster as the cluster administrator.
