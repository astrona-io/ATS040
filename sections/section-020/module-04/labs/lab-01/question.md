# Question

Solve this question on: `terminal`

The `bridge` team wants a pod that keeps a small logbook on a persistent volume and runs through a named runtime configuration. The namespace `starfleet` exists and the StorageClass `standard` is the default.

1. Create a RuntimeClass named `standard-runc` with the handler `runc`.

2. Create a PersistentVolumeClaim named `logbook` in `starfleet`. It requests `100Mi`, uses the access mode `ReadWriteOnce` and the StorageClass `standard`.

3. Create a pod named `recorder` in `starfleet` that uses the RuntimeClass `standard-runc` and mounts the claim `logbook` at `/data`. Its container uses the image `curlimages/curl:8.22.0` and runs `sh -c "echo recorded > /data/entry.txt; sleep 3600"`.

4. The claim must be `Bound`, the pod must be `Running` and the file `/data/entry.txt` must contain `recorded`.

`kubectl` already points at the cluster as the cluster administrator.
