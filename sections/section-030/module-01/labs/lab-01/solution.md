# Solution

Solve this lab on `terminal`. Each step ends with `astrona submit`, which grades the current state.

Start the lab if it is not running:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS040.git -c sections/section-030/module-01/labs/lab-01
```

## Step 1: Write the issue report

Check the mistake first:

```sh
kubectl -n starfleet get deployment scout -o jsonpath='{.spec.template.spec.containers[0].readinessProbe.httpGet.path}{"\n"}'
```

Save this as `issue-report.yaml`:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: issue-report
  namespace: starfleet
data:
  component: scout
  observed: readiness probe calls /healthz
  expected: readiness probe calls /readyz
```

Apply it:

```sh
kubectl apply -f issue-report.yaml
```

## Step 2: Make the focused change

Change only the readiness path. A JSON patch changes one value and nothing else:

```sh
kubectl -n starfleet patch deployment scout --type=json \
  -p='[{"op":"replace","path":"/spec/template/spec/containers/0/readinessProbe/httpGet/path","value":"/readyz"}]'
```

## Step 3: Record the reason and wait for the rollout

```sh
kubectl -n starfleet annotate deployment scout kubernetes.io/change-cause="readiness probe uses /readyz" --overwrite
kubectl -n starfleet rollout status deployment/scout --timeout=180s
```

## Step 4: Grade

```sh
astrona submit --git ssh://git@github.com/astrona-io/ATS040.git -c sections/section-030/module-01/labs/lab-01
```

All five checks pass when the report exists, the readiness path is `/readyz`, nothing else changed, the reason is recorded and `scout` has one ready replica.
