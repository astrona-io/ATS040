# Solution

Solve this capstone on `terminal`. Each step ends with `astrona submit`, which grades the current state.

Start the lab if it is not running:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS040.git -c sections/section-020/capstone/labs/lab-01
```

## Step 1: Harden the Deployment

Edit the Deployment (`kubectl -n orbit edit deployment beacon`). Set `replicas: 3`. Under the container, add `envFrom`, both probes and resources:

```yaml
          envFrom:
            - configMapRef:
                name: beacon-settings
          readinessProbe:
            httpGet:
              path: /readyz
              port: http
            periodSeconds: 5
            failureThreshold: 3
          livenessProbe:
            httpGet:
              path: /healthz
              port: http
            periodSeconds: 10
            failureThreshold: 3
          resources:
            requests:
              cpu: 100m
              memory: 32Mi
            limits:
              memory: 64Mi
```

Wait for the rollout:

```sh
kubectl -n orbit rollout status deployment/beacon
```

## Step 2: Add the disruption budget

Save this as `beacon-pdb.yaml`:

```yaml
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: beacon
  namespace: orbit
spec:
  minAvailable: 2
  selector:
    matchLabels:
      app: beacon
```

Apply it:

```sh
kubectl apply -f beacon-pdb.yaml
```

## Step 3: Add the autoscaler

Save this as `beacon-hpa.yaml`:

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: beacon
  namespace: orbit
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: beacon
  minReplicas: 3
  maxReplicas: 6
  metrics:
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: 70
```

Apply it:

```sh
kubectl apply -f beacon-hpa.yaml
```

The autoscaler needs the CPU request from Step 1, because utilization is a percentage of the request.

## Step 4: Grade

```sh
astrona submit --git ssh://git@github.com/astrona-io/ATS040.git -c sections/section-020/capstone/labs/lab-01
```

All six checks pass when 3 replicas are ready, both probes use the right paths, requests and the memory limit are set, the budget keeps 2 pods available, the settings come from the ConfigMap and the autoscaler is defined with the right bounds and target.
