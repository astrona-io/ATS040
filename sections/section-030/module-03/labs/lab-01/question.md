# Question

Solve this question on: `terminal`

The `bridge` team keeps a record of the facts about its cluster and the Kubernetes release cycle in the namespace `starfleet`.

1. Read the version of the API server of the cluster.

2. Create a ConfigMap named `release-facts` in `starfleet` with these keys:
   - `serverVersion`: the version you read in step 1, for example `v1.35.8` in the form that `kubectl version` prints for the server.
   - `releasesPerYear`: the number of minor releases Kubernetes makes in a year.
   - `supportedMinorVersions`: the number of minor versions that receive patch releases.

3. Add the annotation `owner-sig` with the value `sig-release` to the ConfigMap, which is the group that runs the release process.

`kubectl` already points at the cluster as the cluster administrator.
