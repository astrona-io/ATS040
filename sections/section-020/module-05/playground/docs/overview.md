# Serverless And Event-Driven Playground

A single-node kind cluster (Kubernetes 1.35). Knative and KEDA are not installed. You practice the built-in run-to-completion workloads. Nothing is graded.

## What is in the box

| Object | Namespace | Purpose |
| --- | --- | --- |
| Deployment and Service `scout` | `starfleet` | A web application you can scale by hand |
| Deployment `shuttle` | `starfleet` | A pod with `curl` |

## Practice tasks

1. Scale `scout` to zero and back, and note that nothing starts it on a request.
2. Create a Job that prints a line, wait for it with `kubectl wait --for=condition=complete`, and read its logs.
3. Create a Job whose command is `exit 1` with `backoffLimit: 1` and read how many pods it creates.
4. Create a Job with `activeDeadlineSeconds: 10` and `sleep 60`, and read the reason on the Job.
5. Create a CronJob, then run it at once with `kubectl create job --from=cronjob/NAME`, and suspend it with a patch.
6. Run `kubectl api-resources | grep -i -E "knative|keda"` and confirm that neither is installed.
