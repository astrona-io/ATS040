# Solution

Solve this lab on `terminal`. Each step ends with `astrona submit`, which grades the current state.

Start the lab if it is not running:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS040.git -c sections/section-030/module-02/labs/lab-01
```

## Step 1: Read the manifests and find the served versions

```sh
kubectl -n starfleet get configmap legacy-manifests -o jsonpath='{.data.cronjob\.yaml}'
kubectl api-resources --api-group=batch
kubectl api-resources --api-group=autoscaling
kubectl api-resources --api-group=policy
```

The cluster serves CronJob in `batch/v1`, HorizontalPodAutoscaler in `autoscaling/v2` and PodDisruptionBudget in `policy/v1`. The versions `batch/v1beta1`, `autoscaling/v2beta2` and `policy/v1beta1` are removed.

## Step 2: Save the migrated manifests

Extract each manifest, change only the first line, and apply it. A server-side dry run checks the result first:

```sh
kubectl -n starfleet get configmap legacy-manifests -o jsonpath='{.data.cronjob\.yaml}' | sed 's#^apiVersion: batch/v1beta1#apiVersion: batch/v1#' > cronjob.yaml
kubectl -n starfleet get configmap legacy-manifests -o jsonpath='{.data.hpa\.yaml}' | sed 's#^apiVersion: autoscaling/v2beta2#apiVersion: autoscaling/v2#' > hpa.yaml
kubectl -n starfleet get configmap legacy-manifests -o jsonpath='{.data.pdb\.yaml}' | sed 's#^apiVersion: policy/v1beta1#apiVersion: policy/v1#' > pdb.yaml
kubectl apply --dry-run=server -f cronjob.yaml -f hpa.yaml -f pdb.yaml
```

Review the three files, then apply them:

```sh
kubectl apply -f cronjob.yaml -f hpa.yaml -f pdb.yaml
```

## Step 3: Record the notes

Save this as `migration-notes.yaml`:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: migration-notes
  namespace: starfleet
data:
  cronjob: batch/v1
  hpa: autoscaling/v2
  pdb: policy/v1
```

Apply it:

```sh
kubectl apply -f migration-notes.yaml
```

## Step 4: Grade

```sh
astrona submit --git ssh://git@github.com/astrona-io/ATS040.git -c sections/section-030/module-02/labs/lab-01
```

All five checks pass when the three objects are served at the current versions with their original values, the notes list the versions, and the source ConfigMap and `scout` are unchanged.
