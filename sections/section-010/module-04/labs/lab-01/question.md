# Question

Solve this question on: `terminal`

The team `bridge` owns the namespace `starfleet`. The cluster bill shows that the namespace reserves far more capacity than it uses. The Deployment `scout` requests `500m` CPU and `256Mi` memory. The namespace has no labels, no quota and no container defaults.

1. Label the namespace `starfleet` with `team=bridge` and `cost-center=exploration`, so that a cost report can allocate its cost.

2. Create a ResourceQuota named `compute-budget` in `starfleet` that allows at most 2 CPU of requests, `2Gi` of memory requests, `4Gi` of memory limits and 10 pods.

3. Create a LimitRange named `container-defaults` in `starfleet` with a default request of `50m` CPU and `64Mi` memory, and a default memory limit of `128Mi`, for containers.

4. Right-size `scout`. Set its container requests to `100m` CPU and `64Mi` memory, and its memory limit to `128Mi`. The Deployment must stay available.

`kubectl` already points at the cluster as the cluster administrator.
