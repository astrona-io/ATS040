# Solution

Solve this lab on `terminal`. Each step ends with `astrona submit`, which grades the current state.

Start the lab if it is not running:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS040.git -c sections/section-020/module-03/labs/lab-01
```

## Step 1: Add the requests

Percent utilization is measured against the request, so the autoscaler cannot work without it. Patch the Deployment:

```sh
kubectl -n starfleet set resources deployment/scout --requests=cpu=100m,memory=32Mi
kubectl -n starfleet rollout status deployment/scout --timeout=180s
```

## Step 2: Create the HPA with the behavior

Save this as `hpa-scout.yaml`:

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: scout
  namespace: starfleet
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: scout
  minReplicas: 2
  maxReplicas: 5
  metrics:
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: 60
  behavior:
    scaleUp:
      policies:
        - type: Pods
          value: 2
          periodSeconds: 30
    scaleDown:
      stabilizationWindowSeconds: 120
```

Apply it:

```sh
kubectl apply -f hpa-scout.yaml
```

## Step 3: Wait for the metric and the replicas

Metrics Server needs a short time to report usage for the new pods. Read the conditions until `ScalingActive` is `True`:

```sh
kubectl -n starfleet describe hpa scout
kubectl -n starfleet get deployment scout
```

When the autoscaler is active it raises the Deployment to `minReplicas`, which is 2.

## Step 4: Grade

```sh
astrona submit --git ssh://git@github.com/astrona-io/ATS040.git -c sections/section-020/module-03/labs/lab-01
```

All five checks pass when the requests exist, the HPA has the right bounds, target and behavior, it is active, and two replicas are ready.
