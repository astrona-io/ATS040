# Curriculum Coverage

Exam: Kubernetes and Cloud Native Associate (KCNA). Domain: Cloud Native Architecture (12%).

Verified against the [official objectives](https://training.linuxfoundation.org/certification/kubernetes-cloud-native-associate/) on 2026-10-10. Module titles and questions are original teaching material, not official exam questions.

| Section | Official objective | Modules | Capstone |
| --- | --- | --- | --- |
| 010 | Observability | 1 | Observability Capstone |
| 020 | Cloud Native Ecosystem and Principles | 3 | Architecture Capstone |
| 030 | Cloud Native Community and Collaboration | 2 | Community And API Capstone |

| Section / module | Module | Teaching lessons | Labs | Measurable outcomes |
| --- | --- | --- | --- | --- |
| 010 / 01 | Observability And Reliability | 3 | 1 | Choose metrics, logs or traces for a diagnostic question.; Explain instrumentation, collection and visualization responsibilities.; Distinguish an SLI, SLO and SLA.; Calculate an error budget and relate alerts to user impact.; Scrape a workload with Prometheus, record its error ratio and alert on budget burn. |
| 020 / 01 | Cloud Native Design | 2 | 2 | Explain loose coupling and microservice tradeoffs.; Relate resilience, elasticity and external state to replaceable workloads.; Distinguish serverless execution from the absence of servers.; Explain asynchronous delivery, retries and idempotency.; Harden a workload with replicas, probes, requests, a disruption budget and external settings, and run retried work with Jobs. |
| 020 / 02 | Cloud Native Ecosystem | 2 | 1 | Explain how open standards support interoperability.; Match representative projects to their technical roles.; Distinguish a specification, implementation and managed service.; Choose tools from requirements and operating constraints.; Extend the Kubernetes API with a custom resource definition. |
| 020 / 03 | Autoscaling | 3 | 1 | Explain how the Horizontal Pod Autoscaler computes a replica count from a request-based utilization.; Distinguish horizontal, vertical and cluster scaling.; Explain event-driven scaling, stabilization windows and scaling behavior.; Create an autoscaling/v2 HorizontalPodAutoscaler and tune its behavior. |
| 030 / 01 | Community And Collaboration | 2 | 1 | Explain project governance and foundation maturity categories.; Distinguish licensing permission from contribution acceptance.; Describe an issue, pull request and review workflow.; Identify a suitable SIG or working group for a focused contribution.; Fix a defect as a focused change and record its cause. |
| 030 / 02 | API Maturity And Deprecation | 3 | 1 | Describe alpha, beta and stable API levels and feature gates.; Apply the deprecation policy windows to a version that is going away.; Find clients that still use deprecated versions.; Migrate manifests to current versions and check them with a server-side dry run and a diff. |

Every section begins with an introduction. Every module ends with a summary. Each module has a playground and at least one graded lab, placed after the part it tests. Each section closes with a capstone and a knowledge check (`quiz.yaml`, pass score 70). A final domain quiz closes the course.

The labs, capstones and playgrounds are written and statically checked only. They have not been run, and each lab README says UNTESTED. The Autoscaling module and the API Maturity And Deprecation module were added to give the architecture and API lifecycle objectives hands-on coverage. KEDA and the Vertical Pod Autoscaler are taught for reading only and are not installed in any lab.
