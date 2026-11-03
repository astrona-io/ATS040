# Solution

Solve this lab on `terminal`. Each step ends with `astrona submit`, which grades the current state.

Start the lab if it is not running:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS040.git -c sections/section-010/module-04/labs/lab-01
```

## Step 1: Label, quota and defaults

Save this as `budget.yaml`:

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: starfleet
  labels:
    team: bridge
    cost-center: exploration
---
apiVersion: v1
kind: LimitRange
metadata:
  name: container-defaults
  namespace: starfleet
spec:
  limits:
    - type: Container
      defaultRequest:
        cpu: 50m
        memory: 64Mi
      default:
        memory: 128Mi
---
apiVersion: v1
kind: ResourceQuota
metadata:
  name: compute-budget
  namespace: starfleet
spec:
  hard:
    requests.cpu: "2"
    requests.memory: 2Gi
    limits.memory: 4Gi
    pods: "10"
```

Apply it:

```sh
kubectl apply -f budget.yaml
```

The command may print a warning about a missing annotation on the namespace. The labels are set anyway.

## Step 2: Right-size scout

```sh
kubectl -n starfleet set resources deployment/scout --requests=cpu=100m,memory=64Mi --limits=memory=128Mi
kubectl -n starfleet rollout status deployment/scout --timeout=180s
```

The command changes only the values you name. The old CPU limit of `1` stays, and the check does not read it.

## Grade

```sh
astrona submit --git ssh://git@github.com/astrona-io/ATS040.git -c sections/section-010/module-04/labs/lab-01
```

All checks pass when the namespace has both labels, the quota and the limit range have the right values, scout has the new requests and limit, and the Deployment is available.
