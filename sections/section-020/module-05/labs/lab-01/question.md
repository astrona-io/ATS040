# Question

Solve this question on: `terminal`

The `bridge` team wants a one-off task and a recurring task in the namespace `starfleet`. Both use the image `curlimages/curl:8.22.0`.

1. Create a Job named `beacon`. It runs `sh -c "echo beacon sent"`, retries at most 2 times, stops after 120 seconds in total and is deleted 3600 seconds after it finishes. Its pod must not restart in place.

2. Create a CronJob named `patrol` that runs every five minutes (`*/5 * * * *`) and runs `sh -c "echo patrol done"`. A new run must be skipped while the previous run is still active. Keep only one successful and one failed Job in the history. Each Job it creates must stop after 60 seconds. The pod must not restart in place.

3. The Job `beacon` must complete.

`kubectl` already points at the cluster as the cluster administrator.
