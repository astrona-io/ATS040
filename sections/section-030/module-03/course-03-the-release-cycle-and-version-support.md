---
draft: true
exam_objectives:
  - Cloud Native Community and Collaboration
---
# The Release Cycle And Version Support

Kubernetes ships on a regular schedule. A team that runs Kubernetes has to know the schedule, because it decides how long a version gets security fixes.

## Version numbers

A Kubernetes version has three parts, `major.minor.patch`, for example 1.35.8. The major version has been 1 for years. A **minor release** adds features and removes deprecated ones. A **patch release** only contains bug and security fixes.

## The cadence

The project makes **three minor releases per year**, about every four months. Each release has a **release team** of volunteers, led by a release lead, that handles the schedule, the communication, the documentation, the test signal and the bug triage. A new team is formed for each release.

The main steps of a release cycle:

1. **Enhancements freeze.** The KEPs that will ship must be ready. After this date, no new features are accepted for the release.
2. **Code freeze.** Only fixes are merged. The release branch is cut.
3. **Release candidates.** Alpha, beta and release candidate builds are tested.
4. **The release.** The release team publishes binaries, images, the changelog and the release notes.

Patch releases follow the minor release at a steady pace, usually monthly.

## Which versions get patches

The project maintains release branches for the **three most recent minor versions**. A minor version receives about **12 months of patch support**, followed by a period of about two months to let users upgrade. After that the version reaches end of life and receives no more fixes, including security fixes.

This has a practical result for a team. An old cluster that is no longer supported runs with known, unpatched vulnerabilities. The team has to upgrade at least once a year to stay supported, and upgrades go one minor version at a time. The deprecation policy of the API decides what will stop working in a new minor version.

## Version skew

Components in a cluster must not differ too far in version. The **version skew policy** says, for example, that the kubelet may be up to three minor versions older than the API server, and that kubectl may be one minor version older or newer. Control plane components are upgraded before nodes.

## Release notes

Every release has notes that group changes into features, deprecations, API changes, bug fixes and urgent upgrade notes. The notes are the first place to read before an upgrade.

## Read the version of the cluster

Print the client and the server version:

<!-- astrona:playground:renew -->

```sh
kubectl version
```

The server version is the cluster. The minor number tells you which release it belongs to and, with the schedule, how long its patches continue. Read the version as JSON when a script needs it:

```sh
kubectl version -o json | jq -r .serverVersion.gitVersion
```

Save the minor and patch numbers in a ConfigMap to keep a record. Save this as `release-facts-test.yaml`, and replace the version with the one you read above:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: release-facts-test
  namespace: starfleet
data:
  serverVersion: "v1.35.8"
  releasesPerYear: "3"
  supportedMinorVersions: "3"
```

Apply it:

```sh
kubectl apply -f release-facts-test.yaml
```

Delete it after the exercise with `kubectl -n starfleet delete configmap release-facts-test`.

## Common pitfalls

> [!WARNING]
> - **Believing the cluster is supported because it works.** A version outside the three maintained minors gets no fixes.
> - **Skipping minor versions in an upgrade.** Upgrade one minor at a time.
> - **Reading only the patch number as a sign of risk.** A new minor version also changes APIs and defaults.
> - **Upgrading nodes before the control plane.** The control plane goes first.
