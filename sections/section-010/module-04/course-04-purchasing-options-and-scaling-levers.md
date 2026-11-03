---
draft: true
exam_objectives:
  - Observability
---
# Purchasing Options And Scaling Levers

Right-sized requests and clear ownership reduce waste. Two further groups of decisions change the price itself: how the capacity is bought and how much of it runs at any moment. This part compares the purchase options and lists the practical levers that lower a Kubernetes bill.

## Purchase options

Cloud providers sell the same virtual machine under different terms. The names differ by provider, the ideas are the same.

| Option | How it works | Price | Fits |
| --- | --- | --- | --- |
| On-demand | Pay per second or hour with no commitment | Highest | Unpredictable load, short-lived needs |
| Committed use (reserved instances, savings plans) | Commit to a spend or a size for one to three years | Often 30 to 70 percent lower | The steady baseline that always runs |
| Spot (preemptible) | Unused capacity at a large discount that the provider can take back with short notice | Often 60 to 90 percent lower | Fault-tolerant, interruptible work |

A common design buys the baseline with a commitment, serves the peaks with on-demand nodes and runs interruptible workloads on spot nodes.

## Making a workload spot-ready

A spot node can disappear with a warning of about two minutes or less, depending on the provider. A workload suits spot capacity when it tolerates loss. These Kubernetes features help:

- Several replicas spread over nodes and zones, so one lost node is not an outage.
- A `PodDisruptionBudget`, which limits how many replicas voluntary disruptions may remove at once.
- A graceful shutdown that finishes or hands over work within the `terminationGracePeriodSeconds`.
- Jobs that checkpoint their progress and use `backoffLimit` to retry.
- A node label or taint for spot nodes, with a toleration and node affinity on the workloads that may use them. Stateful databases and single-replica services stay on stable nodes.

## Scaling levers

The cheapest capacity is capacity that is not running. Autoscaling links cost to demand:

- The Horizontal Pod Autoscaler reduces replicas when load falls.
- A cluster autoscaler, or Karpenter on supported clouds, removes underused nodes and picks node sizes that fit the pending pods.
- Scaling non-production environments to zero outside working hours saves the hours of nights and weekends, which are about 70 percent of a week. A CronJob that runs `kubectl scale` or a tool such as KEDA can do this.
- Choosing smaller, fewer node types improves **bin packing**, the fit of pod requests to node capacity, so that less capacity is left over on each node.

## Storage and network levers

- Delete PersistentVolumeClaims and snapshots that no workload uses. A reclaim policy of `Delete` removes the cloud disk with the claim, and `Retain` leaves it, still billed.
- Pick the storage class that matches the need. Fast SSD classes cost more than standard disks.
- Keep chatty services in the same zone when the design allows it, because traffic across zones is billed. Topology-aware routing can prefer endpoints in the same zone.
- Reduce egress with caching and compression, and use private connections to managed services when they are cheaper than public routes.
- Share one ingress controller or load balancer between many Services, instead of one `LoadBalancer` per Service.

## Observability cost

Telemetry is a workload with a bill of its own. High-cardinality metric labels, debug logs in production and 100 percent trace sampling cost storage and money. The same tools that control the signals control the cost: drop unused metrics, sample traces, set retention by value and keep logs in cheaper storage after a few days.

## A simple order of work

1. Make cost visible with labels and a cost tool.
2. Remove what nobody uses: idle environments, disks, load balancers.
3. Right-size requests from measured usage.
4. Autoscale and shut down what does not need to run.
5. Buy the steady baseline with commitments and use spot for interruptible work.

The order matters, because a commitment bought before right-sizing locks in the waste.

## Summing up

Capacity can be bought on-demand, committed or spot, and the best mix puts the steady baseline on commitments and tolerant work on spot. Autoscaling, shutdown of non-production environments and better bin packing reduce the capacity that runs. Storage, network and telemetry follow the same rule of paying only for what is used. Together with visible allocation and right-sized requests, these levers complete the FinOps loop for a cluster.

## Common pitfalls

> [!WARNING]
> - **Committing before right-sizing.** The commitment locks in oversized capacity.
> - **Running stateful or single-replica services on spot nodes.** An interruption becomes an outage.
> - **Autoscaling without requests.** The scaling decisions have no base value, and node scaling reacts to requests.
> - **Forgetting retained volumes.** A claim with a `Retain` policy leaves a billed disk behind.
> - **Optimizing the cluster and ignoring telemetry cost.** Observability data can be a large share of the bill.
