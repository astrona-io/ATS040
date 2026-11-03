---
draft: true
exam_objectives:
  - Cloud Native Ecosystem and Principles
---
# The CNCF Landscape By Category

The cloud native landscape has hundreds of projects. A map by category makes it manageable. This part walks through the main categories with graduated or well-known examples. Knowing which project fills which job is a common exam topic.

## Layers of the landscape

| Category | Job | Examples |
| --- | --- | --- |
| Provisioning | Create infrastructure, manage images and secrets | Terraform and OpenTofu (not CNCF), Crossplane, Harbor, Notary and TUF, cert-manager |
| Runtime | Run containers, store data and connect the network | containerd, CRI-O, Rook, Longhorn, Cilium, Calico, CNI, CSI |
| Orchestration and management | Schedule workloads and find services | Kubernetes, CoreDNS, Envoy, Istio, Linkerd, etcd |
| App definition and development | Build, package and deliver applications | Helm, Argo CD, Flux, Backstage, Buildpacks, Dapr, KEDA |
| Observability and analysis | Collect and analyze telemetry | Prometheus, OpenTelemetry, Jaeger, Fluentd, Thanos, Cortex |
| Security | Secure the supply chain and the runtime | Falco, Open Policy Agent, Kyverno, Trivy, SPIFFE and SPIRE, in-toto |
| Streaming and messaging | Move events and messages | NATS, CloudEvents, Strimzi |
| Serverless | Run functions and event-driven workloads | Knative, OpenFaaS, Fission |
| Platform | Offer combined services | Managed Kubernetes services, Kubernetes distributions |

## Which project does what

- **Kubernetes** schedules and manages containers across machines. **etcd** is its key-value store. **CoreDNS** gives names to Services.
- **containerd** and **CRI-O** run containers. **Envoy** is a proxy and the data plane of several meshes.
- **Istio** and **Linkerd** are service meshes. They add encryption, retries and telemetry between services through proxies.
- **Helm** packages Kubernetes manifests into charts. **Argo CD** and **Flux** do GitOps, which keeps the cluster in sync with a Git repository.
- **Prometheus** collects metrics. **OpenTelemetry** is the standard for telemetry data. **Jaeger** stores traces. **Fluentd** and **Fluent Bit** collect logs.
- **Falco** detects suspicious behavior at runtime. **Open Policy Agent** and **Kyverno** enforce policy at admission. **Trivy** scans images.
- **Harbor** is a container registry with scanning and signing. **cert-manager** issues and renews certificates.
- **Crossplane** manages cloud resources through the Kubernetes API.
- **Backstage** is a developer portal.
- **Rook** runs Ceph storage on Kubernetes.

## Reading the landscape for the right job

Start from the job and not from the logo. Ask what the need is (for example, collect traces), find the category (observability), check the maturity of the projects in it and compare them with your requirements. The landscape shows both CNCF and non-CNCF products, so check which are CNCF projects and at which stage.

## Find the landscape on your own cluster

Every cluster is a small landscape. List the components that run in `kube-system` and name the category of each:

<!-- astrona:playground:renew -->

```sh
kubectl -n kube-system get pods
kubectl get nodes -o jsonpath='{.items[0].status.nodeInfo.containerRuntimeVersion}{"\n"}'
kubectl get storageclass
```

The pods show etcd, the API server, the scheduler, the controller manager, CoreDNS and kube-proxy. The node reports its container runtime. The storage class names the storage provisioner. Each belongs to a layer of the table above.

## Common pitfalls

> [!WARNING]
> - **Treating the landscape as a recommendation list.** It lists what exists, not what fits.
> - **Assuming every logo is a CNCF project.** Many entries are commercial products.
> - **Choosing by category alone.** Compare maturity, license and fit too.
> - **Confusing a data plane with a control plane.** Envoy forwards traffic. A mesh control plane configures it.
