---
draft: true
exam_objectives:
  - Cloud Native Ecosystem and Principles
---
# Evaluating And Adopting A Project

Choosing a cloud native project is a decision the team lives with for years. A short, repeatable evaluation keeps the choice based on evidence. This part gives a method and the questions behind it.

## Step 1: write the requirement

State the job, the constraints and the success measure before looking at products. For example: collect traces from 40 services, store them for 14 days, run inside the cluster, and keep the extra latency under 5 ms. A vague requirement makes every tool look suitable.

## Step 2: build a shortlist

Use the landscape, the CNCF project list and the experience of other teams to find three or four candidates. Prefer open standards, because they keep the cost of changing later low.

## Step 3: check the project

| Question | Where to look |
| --- | --- |
| How mature is the community? | CNCF stage, number of maintainers and their employers |
| Is it actively maintained? | Release dates, open and closed issues, response time |
| Is the license acceptable? | License file, any additional terms |
| Does it fit the platform? | Supported Kubernetes versions, integrations |
| Is it secure? | Security policy, past advisories, the speed of fixes |
| Who uses it? | Adopters list, case studies, end user feedback |
| What does it cost to operate? | Components to run, upgrade effort, skills needed |
| Can we leave? | Data export, standard interfaces, lock-in |

## Step 4: run a proof of concept

Install each candidate with default settings in a test cluster and run the real workload through it. Measure against the success measure from step 1. A proof of concept shows the operational cost in a way a feature list does not: how long the install takes, how upgrades behave and how clear the errors are.

## Step 5: decide and record

Write a short decision record: the requirement, the options, the evidence, the choice and the reasons. The record lets a later team understand why the choice was made and when to revisit it.

## Total cost of ownership

The price of the software is a small part. Count the time to learn, install, upgrade, secure and debug it, the cost of the resources it uses, and the cost of leaving. A free project that needs a full-time engineer is not free.

## Build or buy or use a managed service

A team can run an open source project itself, buy a vendor distribution with support, or use a managed service from a cloud provider. Self-running gives the most control and the most work. A managed service gives the least work and the most dependence on the provider. Open interfaces reduce the cost of moving between them.

## Record the decision on the cluster

Keep the record next to the workload. Annotate the `scout` Deployment with the decision facts and read them back:

<!-- astrona:playground:renew -->

```sh
kubectl -n starfleet annotate deployment scout decision-record=ADR-0001 decided-by=bridge-team --overwrite
kubectl -n starfleet get deployment scout -o jsonpath='{.metadata.annotations}{"\n"}'
```

Remove the annotations with `kubectl -n starfleet annotate deployment scout decision-record- decided-by-`.

## Common pitfalls

> [!WARNING]
> - **Choosing by popularity.** Stars and downloads do not show fit.
> - **Skipping the proof of concept.** Operating cost appears only when you run it.
> - **Counting only license cost.** Include people time and exit cost.
> - **Not writing the decision down.** The next team repeats the work.
