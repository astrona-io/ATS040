---
draft: true
exam_objectives:
  - Cloud Native Ecosystem and Principles
---
# Role-Based Access Control For Personas

A role in an organization should lead to a matching set of permissions in the cluster, and no more. Kubernetes uses **role-based access control (RBAC)** for this. This part explains the objects and applies them to two personas.

## The four RBAC objects

- A **Role** is a set of permissions inside one namespace.
- A **ClusterRole** is a set of permissions for the cluster, or for all namespaces, or for objects that have no namespace.
- A **RoleBinding** gives the permissions of a Role or ClusterRole to a user, a group or a service account inside one namespace.
- A **ClusterRoleBinding** gives a ClusterRole to a subject across the whole cluster.

A permission is a rule: the API groups, the resources and the verbs. The common verbs are `get`, `list`, `watch`, `create`, `update`, `patch` and `delete`. RBAC only allows. There is no deny rule, so a subject has what the sum of its bindings gives, and nothing else.

## Least privilege

The **principle of least privilege** gives each subject the minimum access it needs for its role. A developer who deploys an application needs to change Deployments in the team namespace and does not need to read Secrets or to delete the namespace. An auditor needs to read, not to change.

## Personas as roles

This table maps two personas to access in the namespace `starfleet`:

| Persona | Needs | Access |
| --- | --- | --- |
| Developer | Deploy and debug the team's applications | Read pods, read pod logs, create and update Deployments, no delete, no Secrets |
| Auditor | Inspect the state of the team's applications | Read pods, Deployments, Services and ConfigMaps, no changes, no Secrets |

## Create the roles

Save this as `personas.yaml`:

<!-- astrona:playground:renew -->

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: developer-test
  namespace: starfleet
rules:
  - apiGroups: [""]
    resources: ["pods"]
    verbs: ["get", "list", "watch"]
  - apiGroups: [""]
    resources: ["pods/log"]
    verbs: ["get"]
  - apiGroups: ["apps"]
    resources: ["deployments"]
    verbs: ["get", "list", "watch", "create", "update", "patch"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: developer-test
  namespace: starfleet
subjects:
  - kind: User
    name: geordi
    apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: developer-test
  apiGroup: rbac.authorization.k8s.io
```

Apply it:

```sh
kubectl apply -f personas.yaml
```

The cluster does not store users. The name `geordi` is the identity that a certificate or a token would carry, and the binding refers to it by name.

## Test the access

The administrator can act as another subject with the `--as` flag. `kubectl auth can-i` prints `yes` or `no`:

```sh
kubectl auth can-i create deployments --as geordi -n starfleet
kubectl auth can-i delete deployments --as geordi -n starfleet
kubectl auth can-i get secrets --as geordi -n starfleet
kubectl auth can-i create deployments --as geordi -n default
```

The expected answers are yes, no, no and no. The binding is in `starfleet`, so the same user has no access in `default`. List everything the user may do with:

```sh
kubectl auth can-i --list --as geordi -n starfleet
```

Delete the test objects after the exercise with `kubectl -n starfleet delete rolebinding developer-test` and `kubectl -n starfleet delete role developer-test`.

## Groups and service accounts

Binding a role to each user does not scale. Bind it to a **group** from the identity provider instead, and add people to the group. Applications that run in the cluster use **service accounts**, and the same Role and RoleBinding objects apply to them, with a subject of kind `ServiceAccount`.

## Common mistakes in role design

- A wildcard `*` in resources or verbs gives more than intended, and grows when new resource types appear.
- A ClusterRoleBinding to a persona that only works in one namespace gives access everywhere.
- A role that can create Pods or RoleBindings can often reach more than its list shows, because it can run a pod that mounts a Secret or give itself a stronger role.

## Common pitfalls

> [!WARNING]
> - **Looking for a deny rule.** RBAC has none. Remove the permission instead.
> - **Using `cluster-admin` for convenience.** It gives every right on every resource.
> - **Binding in the wrong scope.** A RoleBinding works in one namespace. A ClusterRoleBinding works in all.
> - **Forgetting `pods/log`.** Logs are a sub-resource and need their own rule.
