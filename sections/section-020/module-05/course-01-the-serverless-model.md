---
draft: true
exam_objectives:
  - Cloud Native Ecosystem and Principles
---
# The Serverless Model

The word serverless is misleading. Servers still exist. The meaning is that the team does not provision, patch or scale them. The platform does that, and the bill follows use instead of reserved capacity. This part defines serverless, the two forms it takes and the trade-offs a team accepts.

## Two forms of serverless

**Functions as a Service (FaaS)** runs small pieces of code, called functions, in response to a trigger such as an HTTP request, a message or a timer. The platform starts the function when work arrives, runs it for a short time and stops it. AWS Lambda, Azure Functions and Google Cloud Functions are managed examples.

**Backend as a Service (BaaS)** replaces parts of an application backend with managed services that are used through an API: a managed database, authentication, file storage or a message queue. The team writes no server code for these parts.

An application often mixes both: functions hold the logic, and managed services hold the state.

## What the platform handles

| Concern | In a virtual machine | In a container platform | In serverless |
| --- | --- | --- | --- |
| Operating system patching | The team | The team or the provider | The provider |
| Capacity planning | The team | The team, with autoscaling | The provider |
| Scaling to demand | The team | Rules the team sets | Automatic, including to zero |
| Billing | Per reserved hour | Per reserved node | Per request or per execution time |

## Benefits

- **No idle cost.** When no request arrives, nothing runs and nothing is billed.
- **Fast scaling.** The platform adds copies of a function as events arrive.
- **Less operations work.** There are no servers to patch.
- **Small units.** A function does one thing, which fits an event-driven design.

## Limits

- **Cold start.** The first request after a quiet period waits while the platform starts a new instance. The delay depends on the runtime and the size of the code.
- **Execution limits.** Managed platforms limit the run time, memory and request size of a function.
- **Statelessness.** An instance can be removed at any time, so state must live outside it.
- **Vendor lock-in.** Function triggers, permissions and limits differ between providers, so a function written for one often needs changes for another.
- **Harder local testing and debugging.** The code depends on events and services that exist in the cloud.

## Serverless and containers

Serverless is not the opposite of containers. Many serverless platforms run functions inside containers. The difference is who manages the container. In a container platform such as Kubernetes the team writes the Deployment, the Service and the scaling rules. In a serverless platform the team provides the code or the image and the platform decides when it runs. Projects such as Knative bring this model to Kubernetes, so a team can run it on its own cluster and avoid the lock-in of one provider.

## Look at an idle application

Save this as `scale-idle.sh` to see how a normal Deployment behaves when it has no traffic. It scales the `scout` Deployment to zero by hand and back:

<!-- astrona:playground:renew -->

```sh
kubectl -n starfleet scale deployment/scout --replicas=0
kubectl -n starfleet get deployment scout
kubectl -n starfleet scale deployment/scout --replicas=1
kubectl -n starfleet rollout status deployment/scout --timeout=120s
```

Run it with `sh scale-idle.sh`. Kubernetes can run zero replicas, but the standard Deployment does not start one when a request arrives. Nothing receives the request while the count is zero. A serverless platform adds the missing part: a component that receives the request, starts a replica and forwards the request.

## Common pitfalls

> [!WARNING]
> - **Reading serverless as no servers.** Servers exist. The provider runs them.
> - **Storing state in a function instance.** The instance can disappear after any request.
> - **Ignoring cold start for latency-sensitive paths.** Measure it before choosing serverless for an interactive request path.
> - **Treating FaaS as the only serverless.** Managed databases, queues and authentication are serverless too.
