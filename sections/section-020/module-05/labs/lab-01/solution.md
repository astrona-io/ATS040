# Solution

Solve this lab on `terminal`. Each step ends with `astrona submit`, which grades the current state.

Start the lab if it is not running:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS040.git -c sections/section-020/module-05/labs/lab-01
```

## Step 1: Save and apply the objects

Save this as `tasks.yaml`:

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: beacon
  namespace: starfleet
spec:
  backoffLimit: 2
  activeDeadlineSeconds: 120
  ttlSecondsAfterFinished: 3600
  template:
    spec:
      restartPolicy: Never
      containers:
        - name: beacon
          image: curlimages/curl:8.22.0
          command: ["sh", "-c", "echo beacon sent"]
---
apiVersion: batch/v1
kind: CronJob
metadata:
  name: patrol
  namespace: starfleet
spec:
  schedule: "*/5 * * * *"
  concurrencyPolicy: Forbid
  successfulJobsHistoryLimit: 1
  failedJobsHistoryLimit: 1
  jobTemplate:
    spec:
      activeDeadlineSeconds: 60
      template:
        spec:
          restartPolicy: Never
          containers:
            - name: patrol
              image: curlimages/curl:8.22.0
              command: ["sh", "-c", "echo patrol done"]
```

Apply it:

```sh
kubectl apply -f tasks.yaml
```

## Step 2: Check the Job and the CronJob

```sh
kubectl -n starfleet wait --for=condition=complete job/beacon --timeout=180s
kubectl -n starfleet logs job/beacon
kubectl -n starfleet get cronjob patrol
```

## Grade

```sh
astrona submit --git ssh://git@github.com/astrona-io/ATS040.git -c sections/section-020/module-05/labs/lab-01
```

All checks pass when the Job and the CronJob set the required limits and the Job completes.
