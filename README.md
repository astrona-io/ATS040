# Cloud Native Architecture (ATS040)

Kubernetes and Cloud Native Associate (KCNA) — Cloud Native Architecture, 12% of the published curriculum. This course is part of ATP008.

Concept lessons explain each official objective through concrete examples, diagrams and scenario reasoning. Each module has a playground for free practice and a graded lab. Each section closes with an integration capstone and a knowledge check, and the course ends with a final domain quiz. Labs run on a local kind cluster with Kubernetes 1.35.

## Course Outline

| Section | Objective | Modules | Labs | Capstone | Quiz |
| --- | --- | --- | --- | --- | --- |
| 010 | Observability | 1 | 1 | 1 | 10 questions |
| 020 | Cloud Native Ecosystem and Principles | 3 | 4 | 1 | 10 questions |
| 030 | Cloud Native Community and Collaboration | 2 | 2 | 1 | 10 questions |

The final domain quiz has 15 questions. See [the curriculum map](CURRICULUM.md) for module outcomes. The manifest `astrona.yaml` registers the readings, labs and quizzes in teaching order.

## Run A Lab

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS040.git -c sections/section-010/module-01/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS040.git -c sections/section-010/module-01/labs/lab-01
```

Playgrounds are in `sections/section-0X0/module-0N/playground/`. Capstones are in `sections/section-0X0/capstone/labs/lab-01/`.

## Authoring Status

Draft. The labs, capstones and playgrounds are written and statically checked only (`astrona validate`, `bash -n` and YAML parsing). They have not been run, so every lab README is marked UNTESTED. Technical sections and the ATP008 registration remain draft until the maintainer approves publication.

## Question Banks

The quiz files `sections/section-0X0/quiz.yaml` and `sections/final-domain-quiz.yaml` are registered in the manifest. The earlier banks in `sections/*/questions.yaml` and `assessments/` are kept and indexed in `assessments/index.yaml`.

## Sources And Contributions

Author references are recorded in [SOURCES.md](SOURCES.md). Report corrections through this repository’s issues. The material uses the repository license.
