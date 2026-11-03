# Solution

Solve this lab on `terminal`. Each step ends with `astrona submit`, which grades the current state.

Start the lab if it is not running:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS040.git -c sections/section-020/module-02/labs/lab-01
```

## Step 1: Create the ConfigMap

Save this as `ecosystem-notes.yaml`:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: ecosystem-notes
  namespace: starfleet
data:
  metrics: observability
  gitops: continuous-delivery
  runtime: container-runtime
  mesh: service-mesh
```

Apply it:

```sh
kubectl apply -f ecosystem-notes.yaml
```

## Step 2: Define the Sensor kind

The CRD name must be the plural name, a dot and the group. The schema sits under `versions[].schema.openAPIV3Schema`. `required` makes `target` mandatory, `minimum` bounds the interval, and `default` fills it when missing. Save this as `crd-sensor.yaml`:

```yaml
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  name: sensors.fleet.example.com
spec:
  group: fleet.example.com
  scope: Namespaced
  names:
    plural: sensors
    singular: sensor
    kind: Sensor
  versions:
    - name: v1
      served: true
      storage: true
      schema:
        openAPIV3Schema:
          type: object
          properties:
            spec:
              type: object
              required: ["target"]
              properties:
                target:
                  type: string
                intervalSeconds:
                  type: integer
                  minimum: 1
                  default: 30
```

Apply it and wait until the API server serves the kind:

```sh
kubectl apply -f crd-sensor.yaml
kubectl wait --for=condition=Established crd/sensors.fleet.example.com --timeout=60s
```

## Step 3: Create the Sensor

Leave out `intervalSeconds`. Save this as `sensor-scout.yaml`:

```yaml
apiVersion: fleet.example.com/v1
kind: Sensor
metadata:
  name: scout-sensor
  namespace: starfleet
spec:
  target: scout
```

Apply it and read the stored object:

```sh
kubectl apply -f sensor-scout.yaml
kubectl -n starfleet get sensor scout-sensor -o jsonpath='{.spec}'
```

The stored object contains `intervalSeconds` with the value 30, which the API server added from the schema default.

## Step 4: Grade

```sh
astrona submit --git ssh://git@github.com/astrona-io/ATS040.git -c sections/section-020/module-02/labs/lab-01
```

All five checks pass when the ConfigMap has the four keys, the CRD is established with the schema, the Sensor exists with the default interval, and the API server rejects invalid sensors.
