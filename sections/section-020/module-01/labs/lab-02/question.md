# Question

Solve this question on: `terminal`

A payment event with the identifier `evt-1001` must be sent to the `probe` Service in `starfleet`, which stands in for the receiving system. The receiver may see the same event twice when a request is retried, so the sender must label the event. A nightly report must also run on a schedule, but it must stay switched off until the team approves it.

1. Create a Job named `process-event` in `starfleet`. Its pod sends an HTTP POST to `http://probe.starfleet.svc.cluster.local/anything` with the header `Idempotency-Key: evt-1001`. Use the image `curlimages/curl:8.22.0`, and make `curl` fail when the server answers with an HTTP error.

2. The Job may retry a failed pod at most four times and must stop after 120 seconds in total. Kubernetes must delete the finished Job after 600 seconds. Choose a valid `restartPolicy`.

3. The Job must complete successfully.

4. Create a CronJob named `nightly-report` in `starfleet` that runs at 02:00 every day. Two runs must never overlap. A run that cannot start within 300 seconds of its schedule is skipped. Keep two finished successful Jobs and two failed Jobs. Create it suspended, so that it never runs.

`kubectl` already points at the cluster as the cluster administrator.
