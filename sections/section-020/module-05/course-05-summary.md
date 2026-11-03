---
draft: true
exam_objectives:
  - Cloud Native Ecosystem and Principles
---
# Summary

Serverless is a model where the platform provisions, scales and bills by use, and the team does not manage servers. The two forms are Functions as a Service, which runs small pieces of code on a trigger, and Backend as a Service, which replaces backend parts with managed services. The benefits are no idle cost, fast scaling and less operations work. The limits are cold starts, execution limits, stateless instances and vendor lock-in.

Knative brings serverless to Kubernetes. Knative Serving describes a workload with one Service resource, keeps immutable revisions, splits traffic between them and scales by request concurrency, down to zero with the help of the activator. Knative Eventing routes CloudEvents from sources through a broker and triggers to subscribers. OpenFaaS and Fission are other function platforms. KEDA scales a Deployment by external event counts such as queue length, and handles the step between zero and one.

Kubernetes has built-in run-to-completion workloads. A Job runs pods to completion with `completions`, `backoffLimit`, `activeDeadlineSeconds` and `ttlSecondsAfterFinished`. A CronJob creates Jobs on a cron schedule and uses `concurrencyPolicy` to control overlap.

The choice between virtual machines, containers and serverless depends on load shape, latency, run time, state, lock-in and who operates the system. Real systems mix them per workload.

- Serverless means no server management, not no servers.
- Knative Serving scales requests, Knative Eventing routes events, KEDA scales by external events.
- Set a deadline, a retry limit and a time to live on every Job.
- Choose per workload, not per company.

<!-- astrona:playground:destroy -->
