---
draft: true
exam_objectives:
  - Cloud Native Community and Collaboration
---
# Custom Resource Versions And Conversion

Built-in APIs follow the maturity convention of `v1alpha1`, `v1beta1` and `v1`. Custom resources follow it too. A project that publishes a custom resource definition (CRD) must be able to change its schema over time without breaking the users of the old version. This part explains how a CRD serves several versions.

## Versions in a CRD

A CRD lists its **versions** in `spec.versions`. Each version has a name, a schema, and two flags:

- `served` says whether the API server answers requests for this version.
- `storage` says whether this version is used to store objects in etcd. Exactly one version has `storage: true`.

An object is stored in one version and can be read in any served version. When a client asks for a version that is not the storage version, the API server converts the object.

## Conversion strategies

- **None.** The server only changes the `apiVersion` field. This works when the schemas of the versions are identical.
- **Webhook.** The server calls a webhook that the project provides to convert between versions. This is needed when fields are renamed or restructured.

## Deprecating a version

A CRD version can be marked `deprecated: true`, with an optional `deprecationWarning`. Clients that use it then get a warning header in the response, in the same way as for built-in deprecations. When a version is removed from `served`, requests for it fail. Objects stored in an old version stay readable until the storage version is migrated, so projects publish a storage migration step and remove the old version from `status.storedVersions` only afterwards.

## A CRD with two versions

Save this as `crd-sensor-test.yaml`. Both versions have the same schema, so conversion strategy `None` is enough. The older version is marked as deprecated:

<!-- astrona:playground:renew -->

```yaml
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  name: beacons.example.test
spec:
  group: example.test
  scope: Namespaced
  names:
    plural: beacons
    singular: beacon
    kind: Beacon
  versions:
    - name: v1beta1
      served: true
      storage: false
      deprecated: true
      deprecationWarning: "example.test/v1beta1 Beacon is deprecated; use example.test/v1"
      schema:
        openAPIV3Schema:
          type: object
          properties:
            spec:
              type: object
              properties:
                message:
                  type: string
    - name: v1
      served: true
      storage: true
      schema:
        openAPIV3Schema:
          type: object
          properties:
            spec:
              type: object
              properties:
                message:
                  type: string
```

Apply it and check the versions:

```sh
kubectl apply -f crd-sensor-test.yaml
kubectl wait --for=condition=Established crd/beacons.example.test --timeout=60s
kubectl get crd beacons.example.test -o jsonpath='{range .spec.versions[*]}{.name} served={.served} storage={.storage}{"\n"}{end}'
```

Create an object in the old version. The API server prints the deprecation warning, and stores the object in the storage version:

```sh
cat <<'EOF' | kubectl apply -f -
apiVersion: example.test/v1beta1
kind: Beacon
metadata:
  name: first
  namespace: starfleet
spec:
  message: hello
EOF
kubectl -n starfleet get beacons.v1.example.test first -o jsonpath='{.apiVersion}{"\n"}'
```

The last command asks for the object in version `v1` and prints its `apiVersion`. Delete the test objects after the exercise with `kubectl -n starfleet delete beacons.v1.example.test first` and `kubectl delete crd beacons.example.test`.

## Common pitfalls

> [!WARNING]
> - **Two storage versions.** Exactly one version must have `storage: true`.
> - **Removing an old version while objects are stored in it.** Migrate the stored objects first.
> - **Using conversion `None` when fields differ.** Use a webhook.
> - **Ignoring a deprecation warning on a CRD.** It follows the same policy as a built-in API.
