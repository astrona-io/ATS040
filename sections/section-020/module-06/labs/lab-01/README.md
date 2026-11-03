---
estimated_duration: 20m
---

# Lab: Give Two Personas The Access They Need

Graded lab for the roles and personas module. The learner creates a developer Role and an auditor Role in one namespace, binds each to a user and checks the effective access. The task is in `question.md`; the walkthrough is in `solution.md`.

Status: UNTESTED. Written and statically checked only. The validation scripts and the reference solution have not been run.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS040.git -c sections/section-020/module-06/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS040.git -c sections/section-020/module-06/labs/lab-01
astrona destroy ats-040-lab-020-06
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-roles-exist.sh` | Roles developer and auditor exist in starfleet |
| `validate-bindings.sh` | RoleBindings bind developer to riker and auditor to data |
| `validate-developer-access.sh` | riker can create Deployments and read logs but cannot delete them or read Secrets |
| `validate-auditor-access.sh` | data can read Pods and Deployments but cannot change them or read Secrets |
| `validate-scope.sh` | Neither user has access in the namespace default |
