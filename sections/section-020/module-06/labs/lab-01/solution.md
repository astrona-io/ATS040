# Solution

Solve this lab on `terminal`. Each step ends with `astrona submit`, which grades the current state.

Start the lab if it is not running:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS040.git -c sections/section-020/module-06/labs/lab-01
```

## Step 1: Save and apply the objects

Save this as `personas.yaml`:

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: developer
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
kind: Role
metadata:
  name: auditor
  namespace: starfleet
rules:
  - apiGroups: ["", "apps"]
    resources: ["pods", "services", "configmaps", "deployments"]
    verbs: ["get", "list", "watch"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: developer-riker
  namespace: starfleet
subjects:
  - kind: User
    name: riker
    apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: developer
  apiGroup: rbac.authorization.k8s.io
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: auditor-data
  namespace: starfleet
subjects:
  - kind: User
    name: data
    apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: auditor
  apiGroup: rbac.authorization.k8s.io
```

Apply it:

```sh
kubectl apply -f personas.yaml
```

## Step 2: Test the access

```sh
kubectl auth can-i create deployments --as riker -n starfleet
kubectl auth can-i delete deployments --as riker -n starfleet
kubectl auth can-i get secrets --as riker -n starfleet
kubectl auth can-i get pods --as data -n starfleet
kubectl auth can-i create deployments --as data -n starfleet
kubectl auth can-i get pods --as data -n default
```

The answers are yes, no, no, yes, no and no.

## Grade

```sh
astrona submit --git ssh://git@github.com/astrona-io/ATS040.git -c sections/section-020/module-06/labs/lab-01
```

All checks pass when the Roles and bindings exist and the effective access of both users matches the task.
