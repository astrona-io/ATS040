# Solution

Solve this lab on `terminal`. Each step ends with `astrona submit`, which grades the current state.

Start the lab if it is not running:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS040.git -c sections/section-020/module-04/labs/lab-01
```

## Step 1: Save and apply the objects

Save this as `logbook.yaml`:

```yaml
apiVersion: node.k8s.io/v1
kind: RuntimeClass
metadata:
  name: standard-runc
handler: runc
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: logbook
  namespace: starfleet
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: standard
  resources:
    requests:
      storage: 100Mi
---
apiVersion: v1
kind: Pod
metadata:
  name: recorder
  namespace: starfleet
spec:
  runtimeClassName: standard-runc
  containers:
    - name: recorder
      image: curlimages/curl:8.22.0
      command: ["sh", "-c", "echo recorded > /data/entry.txt; sleep 3600"]
      volumeMounts:
        - name: logbook
          mountPath: /data
  volumes:
    - name: logbook
      persistentVolumeClaim:
        claimName: logbook
```

Apply it:

```sh
kubectl apply -f logbook.yaml
```

## Step 2: Wait for the pod and check the file

The StorageClass waits for the first consumer, so the claim becomes `Bound` when the pod is scheduled:

```sh
kubectl -n starfleet wait --for=condition=Ready pod/recorder --timeout=180s
kubectl -n starfleet get pvc logbook
kubectl -n starfleet exec recorder -- cat /data/entry.txt
```

## Grade

```sh
astrona submit --git ssh://git@github.com/astrona-io/ATS040.git -c sections/section-020/module-04/labs/lab-01
```

All checks pass when the RuntimeClass, the claim and the pod are defined correctly, the claim is bound and the file holds the word recorded.
