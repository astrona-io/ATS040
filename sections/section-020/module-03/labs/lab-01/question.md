# Question

Solve this question on: `terminal`

The `scout` application in `starfleet` has more visitors every week. It runs as one pod and the team wants the cluster to add pods by itself. Metrics Server is installed. The Deployment `scout` has no resource requests, and no autoscaler exists.

1. Make it possible to scale `scout` on CPU percentage. Set a CPU request of `100m` and a memory request of `32Mi` on the `scout` container.

2. Create a HorizontalPodAutoscaler named `scout` in `starfleet`, using `autoscaling/v2`, for the Deployment `scout`. It keeps between 2 and 5 replicas and aims for an average CPU utilization of 60 percent.

3. Control the speed of change. Scale-down must wait for a stabilization window of 120 seconds. Scale-up must add at most 2 pods per 30 seconds.

4. The autoscaler must be able to read the metric, and `scout` must run at least 2 ready replicas.

`kubectl` already points at the cluster as the cluster administrator.
