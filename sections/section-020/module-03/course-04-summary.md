---
draft: true
exam_objectives:
  - Cloud Native Ecosystem and Principles
---
# Summary

Autoscaling replaces a fixed capacity decision with a control loop. The Horizontal Pod Autoscaler reads metrics, compares them with a target and changes the replica count of a workload. Metrics Server supplies CPU and memory values from the kubelets. For percentage targets, the autoscaler divides usage by the container's resource request, so a workload without a CPU request cannot be scaled on CPU utilization. The core formula is the current replica count multiplied by the ratio of the current value to the target value, rounded up.

Vertical and cluster scaling answer different questions. The Vertical Pod Autoscaler recommends or applies new requests for a pod, and it is a separate project that is installed with its own custom resources. A cluster autoscaler adds nodes when pods stay pending because no node has room, and removes nodes that are underused. The three directions depend on each other: pod requests decide how many pods fit on a node, and pending pods trigger node scaling.

KEDA extends the Horizontal Pod Autoscaler with external triggers such as queue length. It creates and manages a HorizontalPodAutoscaler for a workload, and it can scale the workload to zero when there is no work. The Horizontal Pod Autoscaler alone keeps at least one replica.

The speed of change is controlled by the behavior field. A stabilization window makes the autoscaler use the highest recommendation over a period before it scales down, and policies limit how many pods change in a period. Scale-up reacts at once by default, and scale-down waits 300 seconds by default.

- The autoscaler needs a working metrics API and a request on every container.
- The tolerance is 10 percent: small deviations do not change the replica count.
- The replica count always stays between minReplicas and maxReplicas.
- Horizontal scaling suits stateless workloads, and vertical scaling suits workloads that cannot add replicas.

<!-- astrona:playground:destroy -->
