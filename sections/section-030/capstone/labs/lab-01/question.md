# Question

Solve this question on: `terminal`

The `beacon` application in `orbit` runs two replicas, and neither becomes ready. A team member also left an old manifest for a CronJob named `beacon-sweep` in the ConfigMap `legacy-cronjob` (key `cronjob.yaml`), and the cluster no longer accepts it. Fix the application, bring the CronJob back and leave a record for the project. Keep the image of every workload unchanged.

1. `beacon` has 2 available replicas on a new revision of the Deployment.
2. The Deployment records the reason for the change in its change-cause annotation.
3. The CronJob `beacon-sweep` runs in `orbit` with the schedule and concurrency policy of the legacy manifest, through the API version that the cluster serves.
4. A ConfigMap `change-record` in `orbit` has the keys `replaced-api`, `replacement-api`, `replaced-maturity`, `beta-support-months` and `beta-support-releases`. They state which version was replaced, which version replaces it, its maturity level, and how long the Kubernetes deprecation policy keeps a beta version after deprecation.
5. A ConfigMap `issue-report` in `orbit` has the keys `title` (at least 10 characters), `kind` (`bug`) and `sig` (the special interest group that owns the CronJob API), so that the bug can be reported to the right group.
