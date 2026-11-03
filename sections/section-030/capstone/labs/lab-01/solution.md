# Solution

Solve this capstone on `terminal`. Each step ends with `astrona submit`, which grades the current state.

Start the lab if it is not running:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS040.git -c sections/section-030/capstone/labs/lab-01
```

## Step 1: Find the cause

Look at the pods and at the probe events:

```sh
kubectl -n orbit get pods -l app=beacon
kubectl -n orbit describe pod -l app=beacon
```

The events show that the readiness probe gets HTTP 404. The probe path is `/ready`, and the application serves `/readyz`.

## Step 2: Fix the probe and record the cause

Change the path and roll out the new revision:

```sh
kubectl -n orbit patch deployment beacon --type=json -p='[{"op":"replace","path":"/spec/template/spec/containers/0/readinessProbe/httpGet/path","value":"/readyz"}]'
kubectl -n orbit rollout status deployment/beacon
```

Record the reason:

```sh
kubectl -n orbit annotate deployment beacon kubernetes.io/change-cause="fix readiness path from /ready to /readyz" --overwrite
kubectl -n orbit rollout history deployment/beacon
```

## Step 3: Migrate the CronJob

Read the old manifest:

```sh
kubectl -n orbit get configmap legacy-cronjob -o jsonpath='{.data.cronjob\.yaml}'
```

The version `batch/v1beta1` is no longer served. The `CronJob` kind is in `batch/v1`, and the fields in this manifest are the same there. Save this as `beacon-sweep.yaml`:

```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: beacon-sweep
  namespace: orbit
spec:
  schedule: "*/30 * * * *"
  concurrencyPolicy: Forbid
  jobTemplate:
    spec:
      template:
        spec:
          restartPolicy: Never
          containers:
            - name: sweep
              image: curlimages/curl:8.22.0
              command: ["curl", "-s", "-m", "5", "http://beacon.orbit.svc.cluster.local/healthz"]
```

Check the change against the server, then apply it:

```sh
kubectl diff -f beacon-sweep.yaml
kubectl apply -f beacon-sweep.yaml
```

## Step 4: Write the records

Save this as `records.yaml`:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: change-record
  namespace: orbit
data:
  replaced-api: batch/v1beta1
  replacement-api: batch/v1
  replaced-maturity: beta
  beta-support-months: "9"
  beta-support-releases: "3"
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: issue-report
  namespace: orbit
data:
  title: beacon readiness probe path returns 404
  kind: bug
  sig: sig-apps
```

Apply it:

```sh
kubectl apply -f records.yaml
```

The deprecation policy keeps a beta API version for 9 months or 3 releases after its deprecation, whichever is longer. The CronJob API belongs to the special interest group for applications, `sig-apps`.

## Step 5: Grade

```sh
astrona submit --git ssh://git@github.com/astrona-io/ATS040.git -c sections/section-030/capstone/labs/lab-01
```

All six checks pass when the probe path is `/readyz`, two replicas are available on a new revision, the change cause is recorded, the CronJob exists through `batch/v1`, and both records are complete.
