# Question

Solve this question on: `terminal`

The `beacon` application in `orbit` runs as a single bare replica. Its pods have no probes and no resource requests, and its settings are not read from the ConfigMap `beacon-settings` that already exists in the namespace. A node drain or a crash today means an outage. Make `beacon` ready for production, with every item below in place.

1. At least 3 replicas are ready.
2. The container reports readiness on `/readyz` and liveness on `/healthz`. The application listens on port 9898.
3. The container requests CPU and memory and has a memory limit.
4. A voluntary disruption can never leave fewer than 2 pods running.
5. The container reads all its settings from `beacon-settings` as environment variables.
6. The replica count follows load between 3 and 6 pods, with a target of 70 percent CPU utilization.

Do not change the image or the names of existing objects.
