# Assessments

The course has two kinds of assessment data.

## Quizzes in the manifest

Each section has a `quiz.yaml` with 10 questions, and the course ends with `sections/final-domain-quiz.yaml` with 15 questions. They are listed in `astrona.yaml` as `type: quiz` entries with `pass_score: 70`. The format follows the other Astrona courses: bank identity, scope, then single-choice questions with per-option explanations and a `correct_option`.

| File | Bank id | Questions |
| --- | --- | --- |
| `sections/section-010/quiz.yaml` | `ats040-010` | 10 |
| `sections/section-020/quiz.yaml` | `ats040-020` | 10 |
| `sections/section-030/quiz.yaml` | `ats040-030` | 10 |
| `sections/final-domain-quiz.yaml` | `ats040-final` | 15 |

## Earlier question banks

`assessments/index.yaml` lists the earlier banks in teaching order. They use schema version 1 and the contract in `schemas/question-bank.schema.json`, and the files `sections/*/questions.yaml` and `assessments/domain-review.yaml` hold the questions. They are kept for integration and are not listed in the manifest.

## Fields

- `id`: stable bank or question identity; preserve it when editing wording.
- `scope`: section or domain checkpoint.
- `learning_objective`: the measurable outcome checked by the question.
- `source_readings`: author traceability to the teaching; not learner navigation.
- `prompt`: learner-visible question text.
- `options`: stable option IDs, answer text and per-option feedback.
- `correct_option`: the ID of the single correct option.
- `explanation`: feedback reinforcing the supported answer.

Match answers by option ID, not display position. The banks contain answer keys and are public learning material, so this is not a secure examination bank. Scores are not an official KCNA result. All questions are original and remain draft for review.
