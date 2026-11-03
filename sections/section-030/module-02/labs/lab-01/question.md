# Question

Solve this question on: `terminal`

The platform team found three old manifests that the cluster no longer accepts. They are stored in the ConfigMap `legacy-manifests` in `starfleet`, under the keys `cronjob.yaml`, `hpa.yaml` and `pdb.yaml`. They belong to the application `scout`, which runs in the same namespace.

1. Read the three manifests from the ConfigMap. Find out which API version the cluster serves for each of the three kinds.

2. Migrate the CronJob `report-sweep` to the current stable version and apply it, keeping its schedule, concurrency policy and container unchanged.

3. Migrate the HorizontalPodAutoscaler `scout` and the PodDisruptionBudget `scout-pdb` to their current stable versions and apply them. Keep every value.

4. Record the result in a ConfigMap named `migration-notes` in `starfleet`, with the keys `cronjob`, `hpa` and `pdb`. Each value is the apiVersion that you used for that kind.

Do not edit the ConfigMap `legacy-manifests` or the Deployment `scout`.

`kubectl` already points at the cluster as the cluster administrator.
