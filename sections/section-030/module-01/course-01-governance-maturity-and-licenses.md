---
draft: true
exam_objectives:
  - Cloud Native Community and Collaboration
---
# Governance, Maturity And Licenses

A team plans to depend on a cloud native project and contribute a fix. Governance describes how the project makes decisions, appoints maintainers and handles proposals. A foundation can support shared infrastructure and neutral stewardship, while the project's maintainers and documented processes determine everyday technical decisions.

The Cloud Native Computing Foundation (CNCF) uses Sandbox, Incubating and Graduated categories. They describe project development and evidence assessed through the foundation's process. Sandbox can support early exploration. Incubation requires stronger maturity evidence. Graduation requires broader evidence of adoption, governance and sustainable practice.

These categories are not a performance ranking or a universal security guarantee. A Sandbox project can fit a specialized requirement, while a Graduated project can still be unsuitable for a particular workload. Project status can change, so verify current status when a real selection depends on it rather than memorizing a permanent label.

An open source license grants permissions and sets conditions for using, modifying and distributing software. Those conditions can include preserving notices or making particular source available. Different licenses impose different terms. “Open source” does not mean all code can be copied without obligations.

Contribution rules are related but separate. A project may require a Developer Certificate of Origin (DCO) sign-off or a contributor agreement. It may also require tests, a style guide and a code of conduct. Meeting license obligations does not automatically make a proposed contribution acceptable.

Read the project's published governance and contribution process before making a change. For a dependency decision, examine both legal reuse conditions and technical maintenance evidence. For a contribution, follow the project's acceptance workflow rather than assuming foundation membership creates one identical process for every repository.

## Project Governance In Practice

A governance document can define who accepts proposals, how maintainers are appointed and which decisions require broader discussion. This matters when a team depends on long-term compatibility or wants to propose a significant change. A popular repository without a clear decision process can be harder to collaborate with than its download count suggests.

Foundation processes supply another layer. Maturity criteria can consider adoption, governance, maintainership, release practices and other evidence. The exact criteria and project status can evolve. Record current evidence when making a dependency decision rather than treating a category as a permanent technical fact.

A project can become less actively maintained despite having useful software. A feature can be experimental even in a mature project. Evaluate the particular release and feature, not only the project's overall label. Sustainable use includes an upgrade and vulnerability-response plan.

## License And Contribution Obligations

License terms can require notices, license text or source availability under defined circumstances. A company's internal use and its distribution of modified software can involve different obligations. The practical lesson is to identify the actual license and intended use, rather than infer unrestricted reuse from public source access.

A Developer Certificate of Origin sign-off records a contributor's certification about the contribution under the project's process. A contributor agreement can impose another documented requirement. Neither replaces tests, code review or a maintainer's scope decision.

When proposing a change, follow the repository's contribution instructions and maintain an accurate account of the source material used. When selecting a dependency, assess both permission to use it and evidence that the project can support the expected lifecycle. Governance, licensing and technical suitability answer related but separate questions.

## Common pitfalls

> [!WARNING]
> Maturity categories do not guarantee suitability or flawless security. License permissions and contribution acceptance requirements are separate matters.
