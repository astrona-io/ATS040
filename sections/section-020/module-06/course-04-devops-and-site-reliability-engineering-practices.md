---
draft: true
exam_objectives:
  - Cloud Native Ecosystem and Principles
---
# DevOps And Site Reliability Engineering Practices

The roles from the earlier parts need shared practices to work together. DevOps and site reliability engineering (SRE) describe them. The exam asks for the definitions and the vocabulary.

## DevOps

**DevOps** is a culture and a set of practices that bring development and operations together, so that software is built, tested and released quickly and reliably. The main practices are:

- **Continuous integration and delivery.** Every change is built and tested automatically and can be released at any time.
- **Infrastructure as code.** Infrastructure is described in files, reviewed and versioned like code.
- **Automation.** Repeated manual work is replaced by scripts and pipelines.
- **Shift left.** Testing and security checks move earlier in the process, where a fix costs less.
- **Fast feedback.** Monitoring and short release cycles show the effect of a change soon after it ships.

The **DORA metrics** measure delivery performance: deployment frequency, lead time for changes, change failure rate and time to restore service.

## Site reliability engineering

SRE started at Google. It applies software engineering to operations. A well-known description says that SRE is what happens when you ask a software engineer to design an operations team. The key terms:

- **Service level indicator (SLI).** A measured value of service behavior, such as the share of requests that succeed or the latency of the 99th percentile.
- **Service level objective (SLO).** A target for an SLI, for example that 99.9 percent of requests succeed over 30 days.
- **Service level agreement (SLA).** A contract with consequences, often financial, when a target is missed. An SLA is usually less strict than the internal SLO.
- **Error budget.** The amount of failure the SLO allows. With 99.9 percent over 30 days, about 43 minutes of full outage fit in the budget. While budget is left, the team can ship changes. When it is used up, the team pauses features and works on reliability.
- **Toil.** Manual, repetitive work that grows with the service and has no lasting value. SRE aims to automate it.
- **Blameless postmortem.** A written review of an incident that finds causes in systems and processes and not in a person.

## Incident response

An incident process names an **incident commander**, who coordinates, and other roles for communication and technical work. The aim is to restore service first and to find the root cause afterwards. On-call engineers receive alerts that need human action. Alerts should be based on symptoms the user feels, not on every internal cause.

## Link to Kubernetes

The practices depend on the platform. Rollouts with probes and rollback support safe releases. Metrics and alerts give the SLIs. Labels and annotations name the owner of each service, so an alert reaches the right team.

## Look at an owner label

Ownership information makes incident response faster. Add an owner label to the playground application and read it back:

<!-- astrona:playground:renew -->

```sh
kubectl -n starfleet label deployment scout team=bridge --overwrite
kubectl -n starfleet get deployment scout --show-labels
```

An alert rule or a cost report can now select by `team=bridge`. Remove the label with `kubectl -n starfleet label deployment scout team-`.

## Common pitfalls

> [!WARNING]
> - **Setting an SLO of 100 percent.** It leaves no error budget and stops all change.
> - **Confusing SLO and SLA.** An SLO is an internal target. An SLA is a contract.
> - **Writing a postmortem that names a person as the cause.** Blameless means the system is the focus.
> - **Alerting on every cause.** Alert on symptoms that users feel.
