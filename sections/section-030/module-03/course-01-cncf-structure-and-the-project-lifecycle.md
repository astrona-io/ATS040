---
draft: true
exam_objectives:
  - Cloud Native Community and Collaboration
---
# CNCF Structure And The Project Lifecycle

The Cloud Native Computing Foundation (CNCF) is a vendor-neutral home for cloud native open source projects. It was founded in 2015 as a project of the Linux Foundation, and Kubernetes was the first project that Google donated to it. This part explains who runs the CNCF and how a project moves through its stages.

## The bodies of the CNCF

| Body | Role |
| --- | --- |
| Governing Board | Decides budget, marketing, and business matters. It does not decide technical direction |
| Technical Oversight Committee (TOC) | Sets the technical direction, admits projects and moves them between stages |
| Technical Advisory Groups (TAGs) | Groups of experts for an area such as security, observability, runtime or app delivery. They advise the TOC and help projects |
| End User Community | Companies that use cloud native software and give feedback to the projects and the CNCF |
| Staff | Run the events, the certification program and the support of projects |

The split matters for the exam: business and money belong to the Governing Board, technology belongs to the TOC.

## Project maturity levels

A CNCF project has one of three stages.

- **Sandbox.** An early stage for experimental projects that fit the mission. The bar is low. The aim is to give a project a neutral home and to help it grow.
- **Incubating.** The project is used in production by several organizations, has a healthy number of contributors, a clear governance and a flow of releases.
- **Graduated.** The project is mature and widely adopted. It has passed a security audit, has committers from at least two organizations, shows a stable governance and meets the CNCF Code of Conduct. Kubernetes, Prometheus, Envoy, containerd and Argo are examples.

A project can also be **archived** when it is no longer maintained. Maturity says how stable the community and process are. It does not say that a project is better for a given use or that its API is stable.

Moving up needs a **due diligence** review by the TOC and a vote. The TAGs often do the technical review.

## What the CNCF does for a project

- Holds the trademarks and the domain names, so no one company owns the name.
- Provides funding for infrastructure, security audits and legal support.
- Runs events: KubeCon + CloudNativeCon in North America, Europe and Asia, and regional events.
- Maintains the Cloud Native Landscape, a map of projects and products.
- Runs the certification program: KCNA, KCSA, CKA, CKAD and CKS, and the Kubernetes Certified Service Provider and Kubernetes Training Partner programs.

## Neutral ownership

Under CNCF ownership a project's code stays under an open license, the Apache License 2.0 for most projects, and its governance is open. A project with one company as the only maintainer can not graduate. This is why a graduated project is a lower risk for a team than a project owned by one vendor.

## The Cloud Native Landscape

The landscape is a large public map of projects and products grouped by area, such as provisioning, runtime, orchestration, app definition and observability. It shows the maturity stage of each CNCF project. It is a good starting point to find the options for a need. It is not a recommendation list.

## Check the facts in the cluster

A cluster shows the CNCF projects it uses. Kubernetes itself is graduated. List the images that run in the system namespace and see how many come from CNCF projects:

<!-- astrona:playground:renew -->

```sh
kubectl -n kube-system get pods -o custom-columns=NAME:.metadata.name,IMAGE:.spec.containers[*].image
```

The list includes etcd and CoreDNS, which are graduated CNCF projects. The image names show which project and which version each component is.

## Common pitfalls

> [!WARNING]
> - **Thinking the Governing Board decides technology.** The TOC does.
> - **Treating Graduated as the same as stable API.** Maturity is about the project community and process.
> - **Assuming a Sandbox project is unsafe.** It is early, so check the project before use.
> - **Assuming the CNCF writes the code.** Maintainers and contributors write it; the CNCF provides a neutral home.
