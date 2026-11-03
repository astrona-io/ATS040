---
draft: true
exam_objectives:
  - Cloud Native Ecosystem and Principles
---
# Twelve-Factor Applications And Immutable Infrastructure

Cloud native design builds on a set of rules for applications that run well on a platform. The **twelve-factor app** is a methodology that lists twelve of them. It predates Kubernetes, and most of its factors are now supported by the platform. The exam asks for the ideas and for how they match Kubernetes features.

## The twelve factors

| Factor | Rule | Kubernetes feature |
| --- | --- | --- |
| Codebase | One codebase in version control, many deploys | Git, one image per version |
| Dependencies | Declare and isolate dependencies | The container image |
| Config | Store config in the environment | ConfigMaps, Secrets, environment variables |
| Backing services | Treat databases and queues as attached resources | Services, connection strings in config |
| Build, release, run | Keep the stages separate | Image build, manifest, running pod |
| Processes | Run as stateless processes | Deployments, pods |
| Port binding | Export services by a port | Container ports and Services |
| Concurrency | Scale out with processes | Replicas, the Horizontal Pod Autoscaler |
| Disposability | Start fast and stop gracefully | Probes, `terminationGracePeriodSeconds` |
| Dev/prod parity | Keep environments similar | Same image in each environment |
| Logs | Write logs as an event stream to standard output | The container runtime log |
| Admin processes | Run one-off tasks as processes | Jobs |

## Immutable infrastructure

**Immutable infrastructure** means that a running component is never changed in place. To change it, you build a new version and replace the old one. A container image is immutable: a running container is not patched with a package manager, and a configuration change means a new pod. The opposite, a server that administrators log in to and change by hand, drifts over time until nobody knows its exact state. This is sometimes called a snowflake server.

Immutability gives repeatable deployments, simple rollback (run the old image again) and easy scaling, because every copy is the same. A Deployment applies the idea: a new pod template creates a new ReplicaSet, and the old one scales down.

## Declarative configuration

The platform is driven by **declarative** desired state. You write what you want, and a controller works until the actual state matches. Imperative commands describe steps. Declarative files can be reviewed, versioned and applied again with the same result. This is the base of GitOps.

## Disposability in practice

A process that is disposable can be stopped at any time and started again quickly. Delete a pod of the `scout` Deployment and see the platform replace it:

<!-- astrona:playground:renew -->

```sh
kubectl -n starfleet get pods -l app=scout
kubectl -n starfleet delete pod -l app=scout
kubectl -n starfleet rollout status deployment/scout --timeout=120s
kubectl -n starfleet get pods -l app=scout
```

The new pod has a different name, because pods are replaceable and not repaired. This only works when the application keeps no state in the pod.

## Logs as a stream

The application writes to standard output and does not manage log files:

```sh
kubectl -n starfleet logs deploy/scout --tail=3
```

The platform decides where the stream goes: a file on the node, a log agent or a central store.

## Common pitfalls

> [!WARNING]
> - **Baking config into the image.** The image then differs per environment.
> - **Logging to a file inside the container.** The platform cannot see it.
> - **Fixing a running container by hand.** The change is lost when the pod is replaced.
> - **Treating the twelve factors as Kubernetes rules.** They are application design rules that Kubernetes supports.
