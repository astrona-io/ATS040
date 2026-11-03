---
draft: true
exam_objectives:
  - Cloud Native Community and Collaboration
---
# Judging The Health Of A Project

Maturity labels and licenses tell part of the story. A project can be Graduated and still have a slow week, or be Sandbox and be well run. This part lists signals that show whether a project is healthy and will still be there in two years.

## Signals of activity

- **Release cadence.** Regular releases with release notes. A long gap without a release, or releases that only bump versions, can mean the project is stalled.
- **Commits and merged changes.** Look at the trend over months, not at one week.
- **Issue and pull request response.** How long a first reply takes, and what share of items is closed.
- **Backlog age.** Many old open security issues are a warning.

## Signals of governance and people

- **Number and spread of maintainers.** One maintainer is a single point of failure. Maintainers from several organizations are more resilient.
- **Written governance.** A `GOVERNANCE` file that says how decisions are made and how maintainers are added.
- **Contributor growth.** New names appear and stay.
- **Code of Conduct and contributing guide.** They show that new people are expected and welcome.

## Signals of security

- **Security policy.** A file that tells how to report a vulnerability, and a response time.
- **Advisories.** A list of past vulnerabilities and the speed of fixes.
- **Supply chain practices.** Signed releases, a software bill of materials and dependency updates.
- **Security audit.** Graduated CNCF projects have a third-party audit. The OpenSSF Scorecard gives an automated score of such practices.

## Signals of adoption

- **Adopters list.** Named organizations that use the project in production. The CNCF requires adopters for Incubating and Graduated.
- **Integrations.** Support from other projects and vendors.
- **Documentation quality.** Current, searchable and with upgrade guides.

## Warning signs

- A single company employs all maintainers and the roadmap follows its product.
- A recent license change to a restrictive license.
- Release notes without security fixes for a long time while advisories exist.
- Breaking changes without a deprecation period.

## A checklist in a ConfigMap

Keep a record of the evidence for a decision. Save this as `health-check-test.yaml`:

<!-- astrona:playground:renew -->

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: health-check-test
  namespace: starfleet
data:
  project: podinfo
  releaseCadence: regular
  maintainerOrganizations: "1"
  securityPolicy: "yes"
  license: Apache-2.0
```

Apply it and read it back:

```sh
kubectl apply -f health-check-test.yaml
kubectl -n starfleet get configmap health-check-test -o yaml
```

The values here describe a small project: one maintainer organization is a risk to note. Delete the object after the exercise with `kubectl -n starfleet delete configmap health-check-test`.

## Common pitfalls

> [!WARNING]
> - **Deciding on one signal.** Combine activity, people, security and adoption.
> - **Reading a quiet week as a dead project.** Look at the trend.
> - **Trusting a label over evidence.** Check the repository and the advisories yourself.
> - **Ignoring the exit cost.** Know how to leave before you depend on it.
