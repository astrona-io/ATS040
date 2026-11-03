# Solution

Solve this lab on `terminal`. Each step ends with `astrona submit`, which grades the current state. The `--keep` flag keeps the lab running so you can continue after a failed check.

Start the lab if it is not running:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS040.git -c sections/section-020/module-01/labs/lab-01
```

## Step 1: Create the ConfigMap

The message must live outside the pod template. Save this as `scout-config.yaml`:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: scout-config
  namespace: starfleet
data:
  PODINFO_UI_MESSAGE: "served by a replaceable pod"
```

Apply it:

```sh
kubectl apply -f scout-config.yaml
```

## Step 2: Replace the Deployment

The next file changes the replica count, adds both probes and the requests, and reads the ConfigMap with `envFrom`. Because the old Deployment has an inline `env` entry, applying a file that has no `env` field removes it. Save this as `deployment-scout.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: scout
  namespace: starfleet
  labels:
    app: scout
spec:
  replicas: 3
  selector:
    matchLabels:
      app: scout
  template:
    metadata:
      labels:
        app: scout
    spec:
      containers:
        - name: scout
          image: ghcr.io/stefanprodan/podinfo:6.15.0
          ports:
            - name: http
              containerPort: 9898
          envFrom:
            - configMapRef:
                name: scout-config
          readinessProbe:
            httpGet:
              path: /readyz
              port: http
          livenessProbe:
            httpGet:
              path: /healthz
              port: http
          resources:
            requests:
              cpu: 50m
              memory: 32Mi
            limits:
              memory: 64Mi
```

Apply it and wait for the rollout:

```sh
kubectl apply -f deployment-scout.yaml
kubectl -n starfleet rollout status deployment/scout
```

If `kubectl apply` keeps the old inline variable, remove it with `kubectl -n starfleet set env deployment/scout PODINFO_UI_MESSAGE-`.

## Step 3: Create the PodDisruptionBudget

Save this as `pdb-scout.yaml`:

```yaml
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: scout
  namespace: starfleet
spec:
  minAvailable: 2
  selector:
    matchLabels:
      app: scout
```

Apply it:

```sh
kubectl apply -f pdb-scout.yaml
```

## Step 4: Grade

```sh
astrona submit --git ssh://git@github.com/astrona-io/ATS040.git -c sections/section-020/module-01/labs/lab-01
```

All six checks pass when three replicas are available, both probes and the requests are set, the message comes from `scout-config`, the PodDisruptionBudget exists and `shuttle` still gets HTTP 200 from `scout`.
