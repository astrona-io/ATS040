---
estimated_duration: 20m
---

# Lab: Use A RuntimeClass And A Persistent Volume

Graded lab for the open standards module. The learner creates a RuntimeClass, a PersistentVolumeClaim on the default StorageClass and a pod that uses both and writes a file to the volume. The task is in `question.md`; the walkthrough is in `solution.md`.

Status: UNTESTED. Written and statically checked only. The validation scripts and the reference solution have not been run.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS040.git -c sections/section-020/module-04/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS040.git -c sections/section-020/module-04/labs/lab-01
astrona destroy ats-040-lab-020-04
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-runtimeclass.sh` | RuntimeClass standard-runc has the handler runc |
| `validate-claim-spec.sh` | PersistentVolumeClaim logbook requests 100Mi, ReadWriteOnce, StorageClass standard |
| `validate-pod-spec.sh` | Pod recorder uses RuntimeClass standard-runc and mounts logbook at /data |
| `validate-bound.sh` | The claim is Bound and the pod is Running |
| `validate-file.sh` | The file /data/entry.txt in the pod contains recorded |
