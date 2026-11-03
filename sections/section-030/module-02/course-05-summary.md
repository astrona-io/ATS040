---
draft: true
exam_objectives:
  - Cloud Native Community and Collaboration
---
# Summary

The version in an apiVersion states how stable an API is. An alpha version, such as v1alpha1, is off by default, can change without notice and can be removed at any time. A beta version, such as v1beta1, is more tested and has a documented deprecation period, and the project advises caution in production. A stable version, such as v1, is committed to for the lifetime of the major version and changes only in compatible ways. A feature gate is a switch that turns a feature on or off in the control plane, and a feature moves through alpha, beta and general availability with a default that changes at each step.

The deprecation policy gives users time to react. A stable API version can be deprecated only when a newer stable version exists, and it stays available for at least twelve months or three releases, whichever is longer. A beta version stays available for nine months or three releases after deprecation. An alpha version has no promise. A removal appears in the release notes and the deprecation guide, and a cluster upgrade that crosses a removal breaks every manifest that still uses the old version.

A cluster tells you what it serves. The commands `kubectl api-versions` and `kubectl api-resources` list the groups, versions and kinds. When a client uses a deprecated version, the API server returns a warning header, which `kubectl` prints, and counts the use in the metric `apiserver_requested_deprecated_apis`. The reliable time to find deprecated use is before an upgrade.

Migration changes the apiVersion and then checks the fields, because a new version can rename fields or change defaults. The check is a server-side dry run and a diff, followed by a normal apply.

A custom resource definition lists versions with `served` and `storage` flags, and exactly one version is the storage version. The API server converts between versions with the strategy None or a conversion webhook. A CRD version can be deprecated and later removed once stored objects are migrated.

- A stable version is the only version to build long-lived manifests on.
- A removed version is not an error in the manifest text but in the cluster's API list.
- Warnings appear before a removal, and removal appears at an upgrade.
- Custom resources follow the same naming convention, but each project sets its own promise.

<!-- astrona:playground:destroy -->
