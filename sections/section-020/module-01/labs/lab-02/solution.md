# Solution

Solve this lab on `terminal`. Each step ends with `astrona submit`, which grades the current state. The `--keep` flag keeps the lab running so you can continue after a failed check.

Start the lab if it is not running:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS040.git -c sections/section-020/module-01/labs/lab-02
```

## Step 1: Create the Job

`curl -f` makes `curl` exit with an error on an HTTP status of 400 or above, so the Job controller sees a failed pod and retries. `restartPolicy: Never` makes the controller create a new pod for each retry, which keeps the logs of every attempt. Save this as `job-process-event.yaml`:

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: process-event
  namespace: starfleet
spec:
  backoffLimit: 4
  activeDeadlineSeconds: 120
  ttlSecondsAfterFinished: 600
  template:
    spec:
      restartPolicy: Never
      containers:
        - name: worker
          image: curlimages/curl:8.22.0
          command:
            - curl
            - -fsS
            - -X
            - POST
            - -H
            - "Idempotency-Key: evt-1001"
            - http://probe.starfleet.svc.cluster.local/anything
```

Apply it and wait for completion:

```sh
kubectl apply -f job-process-event.yaml
kubectl -n starfleet wait --for=condition=complete job/process-event --timeout=120s
```

## Step 2: Create the CronJob

Save this as `cronjob-nightly-report.yaml`:

```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: nightly-report
  namespace: starfleet
spec:
  schedule: "0 2 * * *"
  concurrencyPolicy: Forbid
  startingDeadlineSeconds: 300
  successfulJobsHistoryLimit: 2
  failedJobsHistoryLimit: 2
  suspend: true
  jobTemplate:
    spec:
      template:
        spec:
          restartPolicy: Never
          containers:
            - name: report
              image: curlimages/curl:8.22.0
              command: ["curl", "-fsS", "http://probe.starfleet.svc.cluster.local/get"]
```

Apply it:

```sh
kubectl apply -f cronjob-nightly-report.yaml
```

## Step 3: Grade

```sh
astrona submit --git ssh://git@github.com/astrona-io/ATS040.git -c sections/section-020/module-01/labs/lab-02
```

All five checks pass when the Job has the retry limits, a valid restart policy, the idempotency header and a completed run, and the CronJob has the requested policy and is suspended.
