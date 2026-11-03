---
draft: true
exam_objectives:
  - Cloud Native Ecosystem and Principles
---
# Troubleshooting Autoscaling

Autoscaling that does not scale is a common problem. The Horizontal Pod Autoscaler reports why in its status and events. This part lists the causes and how to read them.

## Where to look

`kubectl describe hpa` prints the current and target metrics, the replica counts, the conditions and the events. Three conditions matter:

- **AbleToScale** says whether the controller can read and change the scale of the target.
- **ScalingActive** says whether the metrics are readable and scaling is enabled. A status of `False` means the controller has no usable metric.
- **ScalingLimited** says whether the desired count was capped by the minimum or maximum.

## Common causes

| Symptom | Likely cause | Check |
| --- | --- | --- |
| Current metric shows `<unknown>` | The Metrics Server is missing or not ready | `kubectl top pods`, `kubectl -n kube-system get pods` |
| Event `FailedGetResourceMetric` with a message about missing request | The pod has no CPU request, so a percentage cannot be calculated | Resources of the container |
| Replicas stay at the maximum | `maxReplicas` is too low for the load | `ScalingLimited` condition |
| Replicas do not drop | The scale-down stabilization window of 300 seconds is active | The `behavior` field |
| Replicas change too often | Short windows and a noisy metric | Stabilization and policies |
| Pods stay `Pending` after a scale-up | The nodes have no room | Events of the pod |
| Scaling ignores a new metric | The HPA targets the wrong object | `scaleTargetRef` |

## The utilization trap

Resource utilization is calculated against the **request**, not the limit and not the node. A container that requests 100m and uses 80m is at 80 percent, even if the node is idle. A request that is too high makes the percentage look low and delays scale-up. A request that is too low makes the percentage high and scales up early.

## Do not set replicas in the Deployment manifest

When an HPA manages a Deployment, the manifest should not set `replicas`. Each `kubectl apply` of the manifest would reset the replica count to the file value and fight the autoscaler. Leave the field out.

## Create an HPA and read its status

Save this as `hpa-scout-test.yaml`:

<!-- astrona:playground:renew -->

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: scout-test
  namespace: starfleet
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: scout
  minReplicas: 1
  maxReplicas: 3
  metrics:
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: 50
```

Apply it and read the status:

```sh
kubectl apply -f hpa-scout-test.yaml
kubectl -n starfleet describe hpa scout-test
```

Read the conditions block. Right after creation the metric can show as unknown for a short time, until the Metrics Server has collected data. Run the describe command again after about a minute. Delete the object after the exercise with `kubectl -n starfleet delete hpa scout-test`.

## Common pitfalls

> [!WARNING]
> - **Blaming the HPA when pods are Pending.** The scheduler or the cluster scaler is the next step.
> - **Reading utilization against the limit.** It is calculated against the request.
> - **Keeping `replicas` in a manifest that an HPA manages.** Applying it resets the count.
> - **Changing the HPA while the Metrics Server is down.** Fix the metrics pipeline first.
