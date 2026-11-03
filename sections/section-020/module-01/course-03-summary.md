---
draft: true
exam_objectives:
  - Cloud Native Ecosystem and Principles
---
# Summary

Cloud native design lets the platform replace any instance of a workload. Loose coupling keeps each service behind a stable interface, so a team can change, scale and release one service without changing the others. Splitting an application into microservices gives independent release and scaling, but it also adds network calls, partial failure and version compatibility work. A split is useful only when those costs are smaller than the benefit.

Resilience comes from several settings that work together. Several replicas remove the single point of failure. A readiness probe removes a pod from a Service while it cannot serve, and a liveness probe makes the kubelet restart a container that is stuck. A PodDisruptionBudget limits how many replicas a voluntary disruption such as a node drain can remove at once. Resource requests tell the scheduler how much room a pod needs. Configuration in a ConfigMap and durable data in storage outside the container keep the instance itself disposable.

Serverless means the platform starts, scales and bills the execution environment, so the developer does not manage servers. The servers still exist. Scale to zero removes idle cost, and the price is a cold start when the first request arrives. Event-driven systems send work through brokers and queues. Most brokers deliver at least once, so a handler can see the same message twice, and an idempotency key makes a second delivery safe.

Kubernetes runs finite work with a Job and scheduled work with a CronJob. A Job retries failed pods up to `backoffLimit`, stops at `activeDeadlineSeconds` and can clean up with `ttlSecondsAfterFinished`. A CronJob creates Jobs on a schedule, and `concurrencyPolicy` decides what happens when a run overlaps the next one.

- Replace instances, do not repair them: state and configuration live outside the container.
- Readiness controls traffic, liveness controls restarts, and the two answer different questions.
- At-least-once delivery plus an idempotent handler gives the effect of one execution.
- Retries need a limit and a deadline, or a failing task runs forever.

<!-- astrona:playground:destroy -->
