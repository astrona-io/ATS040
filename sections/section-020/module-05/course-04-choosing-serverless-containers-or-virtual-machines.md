---
draft: true
exam_objectives:
  - Cloud Native Ecosystem and Principles
---
# Choosing Serverless, Containers Or Virtual Machines

No model fits every workload. The exam and real projects both ask which one to choose for a given case. This part gives a set of questions and a comparison to answer it.

## The three models

| Model | The team manages | Typical use |
| --- | --- | --- |
| Virtual machine | Operating system, runtime, application, scaling | Legacy software, special kernel needs, long-lived stateful systems |
| Container platform (Kubernetes) | Image, deployment, scaling rules, networking | Microservices, steady load, portable workloads |
| Serverless | Code or image and its triggers | Spiky or rare events, glue code, scheduled tasks |

## Questions that decide

1. **How steady is the load?** A service with constant traffic is cheaper on reserved capacity. A service that is idle most of the day is cheaper when it scales to zero.
2. **How sensitive is it to latency?** A cold start adds delay to the first request. A path where users wait may need a warm instance.
3. **How long does a task run?** Managed function platforms limit run time. A task that runs for hours fits a Job or a container better.
4. **Does it hold state?** Serverless instances are replaceable, so state belongs outside. A database or a stateful system needs a different model.
5. **How much lock-in is acceptable?** A managed FaaS is the least portable. Knative on Kubernetes keeps the workload on open interfaces.
6. **Who operates it?** A small team with no operations capacity gains most from a managed service. A platform team can offer serverless on top of Kubernetes to its developers.

## A cost comparison, in words

A function is billed for the time it runs, so a function that runs for one second a day costs almost nothing. A container that runs all day is billed all day, even when it handles one request. The curves cross: above a certain steady load, the always-on container is the cheaper choice. The point depends on the provider prices and the workload, so teams measure it instead of assuming it.

## Combining the models

Real systems mix the models. A common design runs the core service as containers on Kubernetes, uses functions for event handlers and glue, uses Jobs for batch work and uses managed services for state. The platform choice is per workload and not per company.

## Check the idle behavior yourself

The `scout` Deployment in the playground runs all day. Read its resource requests to see what an idle always-on container reserves:

<!-- astrona:playground:renew -->

```sh
kubectl -n starfleet get deployment scout -o jsonpath='{.spec.template.spec.containers[0].resources}'
```

The requests are reserved on the node whether the application handles traffic or not. This reserved capacity is the cost that scale to zero removes, and the cold start is what it costs in return.

## Common pitfalls

> [!WARNING]
> - **Choosing serverless for steady high load by default.** Reserved capacity can cost less.
> - **Choosing containers for a once-a-day script.** A CronJob or a function wastes less.
> - **Counting only compute cost.** Include operations time, lock-in and the cost of a rewrite.
> - **Treating the choice as global.** Pick per workload.
