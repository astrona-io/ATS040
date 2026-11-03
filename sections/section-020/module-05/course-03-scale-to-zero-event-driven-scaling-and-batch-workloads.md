---
draft: true
exam_objectives:
  - Cloud Native Ecosystem and Principles
---
# Scale To Zero, Event-Driven Scaling And Batch Workloads

Not every workload answers requests. Some process a queue, some run on a schedule and some run once and finish. This part covers the Kubernetes tools for these workloads and the project that scales workloads by event count.

## KEDA

**KEDA** (Kubernetes Event-driven Autoscaling) is a CNCF graduated project. It adds a `ScaledObject` resource. A ScaledObject points at a Deployment and names a **scaler**, which reads a metric from an external system: the length of a Kafka topic, the depth of a queue, a Prometheus query, a cron schedule and many more. KEDA creates and manages a Horizontal Pod Autoscaler for the range from one replica up, and it handles the step between zero and one itself. When the queue is empty, the Deployment has zero replicas. When messages arrive, KEDA scales it to one and then hands over to the Horizontal Pod Autoscaler.

The difference to Knative Serving is the trigger. Serving scales by incoming HTTP requests. KEDA scales by the size of work waiting somewhere else.

## Jobs

A **Job** runs pods until a set number of them finish successfully. It is the Kubernetes object for a task with an end: a database migration, a report, a batch conversion.

Important fields:

- `completions` is the number of successful pods the Job needs.
- `parallelism` is how many pods run at the same time.
- `backoffLimit` is the number of retries before the Job is marked failed. The default is 6.
- `activeDeadlineSeconds` limits the total run time. When it passes, Kubernetes stops the pods and marks the Job failed.
- `ttlSecondsAfterFinished` deletes the Job and its pods that many seconds after it finishes, so finished Jobs do not pile up.
- `restartPolicy` of the pod must be `Never` or `OnFailure` in a Job.

Save this as `job-beacon-test.yaml`:

<!-- astrona:playground:renew -->

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: beacon-test
  namespace: starfleet
spec:
  backoffLimit: 2
  activeDeadlineSeconds: 120
  ttlSecondsAfterFinished: 300
  template:
    spec:
      restartPolicy: Never
      containers:
        - name: beacon
          image: curlimages/curl:8.22.0
          command: ["sh", "-c", "echo beacon sent"]
```

Apply it and read the result:

```sh
kubectl apply -f job-beacon-test.yaml
kubectl -n starfleet wait --for=condition=complete job/beacon-test --timeout=120s
kubectl -n starfleet logs job/beacon-test
```

After 300 seconds the Job and its pod disappear.

## CronJobs

A **CronJob** creates a Job on a schedule written in the cron format of five fields: minute, hour, day of month, month and day of week. The expression `*/5 * * * *` means every five minutes.

Fields that matter:

- `concurrencyPolicy` decides what happens when the previous Job still runs: `Allow` (the default), `Forbid` skips the new run and `Replace` stops the old one.
- `successfulJobsHistoryLimit` and `failedJobsHistoryLimit` set how many finished Jobs are kept. The defaults are 3 and 1.
- `startingDeadlineSeconds` is how late a missed run may still start.
- `suspend` stops new runs without deleting the CronJob.

Save this as `cronjob-patrol-test.yaml`:

```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: patrol-test
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

Apply it and read its status:

```sh
kubectl apply -f cronjob-patrol-test.yaml
kubectl -n starfleet get cronjob patrol-test
```

To run it at once without waiting for the schedule, create a Job from it:

```sh
kubectl -n starfleet create job patrol-manual --from=cronjob/patrol-test
```

Delete the test objects after the exercise with `kubectl -n starfleet delete cronjob patrol-test` and `kubectl -n starfleet delete job patrol-manual`.

## Summing up

Jobs and CronJobs are the built-in serverless-style workloads of Kubernetes: they run, finish and release their resources. KEDA adds scaling by external events. Knative adds request-driven scaling and event routing. The three solve different parts of the same problem.

## Common pitfalls

> [!WARNING]
> - **A Job pod with `restartPolicy: Always`.** The API rejects it. Use `Never` or `OnFailure`.
> - **No `activeDeadlineSeconds`.** A stuck task runs forever and keeps its resources.
> - **No `ttlSecondsAfterFinished`.** Finished Jobs and pods stay until someone deletes them.
> - **A CronJob with `Allow` and a task that runs longer than the interval.** Runs overlap. Use `Forbid` when they must not.
> - **Wrong cron field order.** The first field is the minute, not the hour.
