---
draft: true
exam_objectives:
  - Observability
---
# Summary

A Kubernetes cluster is billed for provisioned compute, storage, network, load balancers and managed services, and not for the work that pods do. The cluster hides cost because teams share nodes and resources are easy to create and forget. FinOps is the practice that repeats three phases: inform, which allocates and reports cost, optimize, which removes waste, and operate, which keeps the result with budgets and regular review. Unit cost, such as cost per request, shows whether efficiency improves while a business grows.

Resource requests decide how much capacity the scheduler reserves, so oversized requests become cost even when usage is low. Comparing `kubectl top` with the declared requests shows the gap, and right-sizing sets requests from measured percentiles with a margin. CPU can be throttled but memory overruns kill the container, so memory needs a higher margin. A ResourceQuota caps the total of a namespace, and a LimitRange gives container defaults and bounds to pods created later.

Allocation needs consistent labels on namespaces and workloads. Showback reports cost to teams and chargeback transfers it to their budget. OpenCost, a CNCF project, joins prices, requests, usage and metadata to compute cost, idle cost and efficiency, and exposes them as Prometheus metrics. Kubecost is a commercial product built on it.

Capacity can be bought on-demand, with commitments or as spot capacity that the provider can take back. Commitments fit the steady baseline and spot fits interruptible work that uses replicas, disruption budgets and graceful shutdown. Autoscaling, shutting down non-production environments, better bin packing, cleaning up volumes and sharing load balancers lower the bill further.

- Requests, not usage, decide how many nodes the scheduler needs.
- Right-size before you commit to a purchase plan.
- Idle cost is capacity that no pod reserves.
- A Retain reclaim policy leaves a billed disk behind.

<!-- astrona:playground:destroy -->
