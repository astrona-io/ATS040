# Cloud Native Roles And Personas Playground

A single-node kind cluster (Kubernetes 1.35). `kubectl` runs as the cluster administrator, which can act as any user with `--as`. Nothing is graded.

## What is in the box

| Object | Namespace | Purpose |
| --- | --- | --- |
| Deployment and Service `scout` | `starfleet` | A web application |
| Deployment `shuttle` | `starfleet` | A pod with `curl` |

## Practice tasks

1. Run `kubectl auth can-i --list -n starfleet` and `kubectl auth whoami`.
2. Create a Role that reads pods and a RoleBinding to a user, then test with `kubectl auth can-i --as`.
3. Test the same user in the namespace `default` and read why the answer differs.
4. Bind a Role to a group with `--group` in `kubectl create rolebinding` and test with `--as-group`.
5. Create a ServiceAccount, bind a Role to it and test with `--as system:serviceaccount:starfleet:NAME`.
6. Add a label `team=bridge` to the `scout` Deployment and select by it.
