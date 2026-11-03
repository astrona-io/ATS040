# Solution

Solve this lab on `terminal`. Each step ends with `astrona submit`, which grades the current state.

Start the lab if it is not running:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS040.git -c sections/section-030/module-03/labs/lab-01
```

## Step 1: Read the server version

```sh
kubectl version -o json | jq -r .serverVersion.gitVersion
```

## Step 2: Create the ConfigMap

Replace the version below with the one you read. Save this as `release-facts.yaml`:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: release-facts
  namespace: starfleet
  annotations:
    owner-sig: sig-release
data:
  serverVersion: "v1.35.8"
  releasesPerYear: "3"
  supportedMinorVersions: "3"
```

Apply it:

```sh
kubectl apply -f release-facts.yaml
```

## Step 3: Check it

```sh
kubectl -n starfleet get configmap release-facts -o yaml
```

## Grade

```sh
astrona submit --git ssh://git@github.com/astrona-io/ATS040.git -c sections/section-030/module-03/labs/lab-01
```

All checks pass when the ConfigMap holds the live server version and the correct release facts and carries the annotation.
