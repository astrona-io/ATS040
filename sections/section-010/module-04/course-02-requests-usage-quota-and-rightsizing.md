---
draft: true
exam_objectives:
  - Observability
---
# Requests, Usage, Quota And Right-Sizing

The scheduler does not look at how much CPU a pod uses. It looks at how much the pod requests. A node can be 90 percent idle in reality and full in the eyes of the scheduler, and the cluster then adds another node that the provider bills. Right-sizing means making the requests match the real need. This part shows how to see the gap and how to give a namespace a budget.

## Requests decide the node count

A **resource request** is the amount of CPU or memory that Kubernetes reserves for a container. The scheduler adds up the requests of the pods on a node, and a pod fits only if the sum stays within the node's allocatable capacity. A **limit** is the maximum that the container may use: CPU above the limit is throttled, and memory above the limit makes the container stop with an out-of-memory kill.

If pods request 2 CPU and use 0.2 CPU, ten of them reserve 20 CPU and use 2. The cluster needs nodes for 20. The cost follows the requests, and the benefit follows the usage. The distance between them is waste.

## Compare requests and usage

<!-- astrona:playground:renew -->

In the playground, `scout` requests far more than it uses. Read the request:

```sh
kubectl -n starfleet get deployment scout -o jsonpath='{.spec.template.spec.containers[0].resources}'
```

Read the real usage. Metrics Server needs about a minute after the cluster starts, so repeat the command if it reports that metrics are not available yet:

```sh
kubectl top pod -n starfleet
```

The columns show CPU in millicores (`m`, one thousandth of a CPU) and memory in mebibytes. Compare the CPU column with the request. A request that is many times the usage is a candidate for right-sizing.

## Quality of Service classes

Kubernetes assigns each pod a Quality of Service (QoS) class from its requests and limits, and uses it to choose which pods to evict when a node runs out of memory:

| Class | Condition | Meaning |
| --- | --- | --- |
| Guaranteed | Every container has requests equal to limits for CPU and memory | Evicted last |
| Burstable | At least one request is set, and the pod is not Guaranteed | Evicted after BestEffort |
| BestEffort | No requests or limits at all | Evicted first |

BestEffort pods look free because they reserve nothing, but they are the first to be killed and the scheduler places them blindly. Production workloads should be Burstable or Guaranteed with realistic requests.

## How to right-size

Right-sizing is a loop of measuring and adjusting:

1. Measure usage over a representative period that includes peak load: the 95th or 99th percentile of CPU and the maximum of memory.
2. Set the CPU request near the typical usage plus a margin, because CPU can be throttled and recovers.
3. Set the memory request and limit above the maximum seen, because a memory overrun kills the container.
4. Apply the change and watch for throttling, restarts and latency.

The Vertical Pod Autoscaler (VPA) automates the measuring. In its recommendation mode it only writes suggested requests to its status, and in an automatic mode it also applies them. Tools such as OpenCost show the same gap as money.

## Limit what a namespace can use

Two objects give a namespace a budget and defaults.

A **ResourceQuota** caps the total that a namespace can request or create. Save this as `quota-starfleet.yaml`:

```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: compute-budget
  namespace: starfleet
spec:
  hard:
    requests.cpu: "2"
    requests.memory: 2Gi
    limits.memory: 4Gi
    pods: "10"
```

Apply it:

```sh
kubectl apply -f quota-starfleet.yaml
```

Then check how much of the budget is used:

```sh
kubectl -n starfleet describe resourcequota compute-budget
```

The output lists each resource with its used and hard values. When a new pod would exceed a value, the API server rejects the request with a `forbidden` error. When a quota covers CPU or memory, every new pod must set that request, or the API server rejects the pod unless a LimitRange provides a default.

A **LimitRange** sets defaults and bounds per container in a namespace. Save this as `limitrange-starfleet.yaml`:

```yaml
apiVersion: v1
kind: LimitRange
metadata:
  name: container-defaults
  namespace: starfleet
spec:
  limits:
    - type: Container
      defaultRequest:
        cpu: 50m
        memory: 64Mi
      default:
        memory: 128Mi
      max:
        memory: 512Mi
```

Apply it with `kubectl apply -f limitrange-starfleet.yaml`. A container created in the namespace without a request now gets `50m` CPU and `64Mi` memory, and a container that asks for more than `512Mi` of memory limit is rejected. The defaults apply only to pods created after the LimitRange exists.

## Summing up and what is still open

The scheduler reserves requests, the provider bills nodes, so oversized requests become cost. `kubectl top` against the declared request shows the gap, and right-sizing closes it with measured percentiles. A ResourceQuota caps a namespace and a LimitRange provides defaults. What remains is attribution: who owns the cost of each workload.

## Common pitfalls

> [!WARNING]
> - **Cutting requests to the average.** Peak load then throttles CPU or kills the container for memory.
> - **Equal requests for every workload.** Requests are per workload and come from its own measurements.
> - **A quota without defaults.** Pods that do not set requests are rejected, which surprises teams.
> - **Expecting a LimitRange to change running pods.** It applies to new pods only.
> - **Memory limit set to the average.** A memory overrun is an out-of-memory kill and not a slowdown.
