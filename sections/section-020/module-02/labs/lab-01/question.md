# Question

Solve this question on: `terminal`

The starfleet platform team keeps a small note of which kind of tool handles which platform job. It also wants to describe its sensors as Kubernetes objects, so that `kubectl` and access control work on them like on any other object. The application `scout` runs in `starfleet`.

1. Create a ConfigMap named `ecosystem-notes` in `starfleet` with four keys. The value of each key is the category of project that does the job:
   - `metrics` has the value `observability`
   - `gitops` has the value `continuous-delivery`
   - `runtime` has the value `container-runtime`
   - `mesh` has the value `service-mesh`

2. Add a new kind `Sensor` to the cluster API. The group is `fleet.example.com`, the version is `v1`, the plural name is `sensors`, and a sensor lives in a namespace.

3. A sensor has a `spec` with a required string field `target` and an integer field `intervalSeconds`. The interval must be at least 1, and it is 30 when the user leaves it out.

4. Create a Sensor named `scout-sensor` in `starfleet` that targets `scout`. Do not set the interval yourself.

The API server must reject a sensor with an interval of 0 and a sensor without a target.

`kubectl` already points at the cluster as the cluster administrator.
