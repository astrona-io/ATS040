---
draft: true
exam_objectives:
  - Cloud Native Community and Collaboration
---
# Open Source Licenses In Depth

A license decides what a team may do with a project: use it, change it, ship it inside a product, or offer it as a service. The wrong assumption can force a team to open its own code or to remove a dependency late in a project. This part goes deeper than a name, so you can read what a license means for use.

## What a license grants

Open source licenses are approved against the Open Source Definition by the Open Source Initiative. All of them allow use, study, change and redistribution. They differ in the conditions that come with redistribution.

## Permissive licenses

A **permissive** license asks for little: keep the copyright notice and the license text. You may include the code in a closed-source product.

| License | Conditions | Patent grant |
| --- | --- | --- |
| MIT | Keep the notice | Not explicit |
| BSD (2-clause and 3-clause) | Keep the notice. The 3-clause form forbids using the authors' names to endorse | Not explicit |
| Apache License 2.0 | Keep the notice, state changes, include the NOTICE file | Explicit grant from contributors |

The CNCF requires most projects to use **Apache License 2.0**, which includes an explicit patent license. If a user sues over a claim that the project infringes a patent, the patent license of that user ends.

## Copyleft licenses

A **copyleft** license requires that a distributed work built from the code is offered under the same license.

- **GPL** requires that a combined work you distribute is also GPL, with its source.
- **LGPL** is weaker. A program may link to an LGPL library without becoming LGPL, but changes to the library itself must stay open.
- **AGPL** adds a rule for network use. If users interact with a modified version over a network, the source must be offered to them, even when the software is not distributed.
- **MPL 2.0** applies at file level: changes to MPL files stay open, and the rest of the product does not.

Copyleft is not a problem when you use a tool and do not distribute it. A company can run GPL software internally without publishing anything. The conditions apply to distribution, and for the AGPL also to network service.

## Source-available licenses

Some projects have changed from an open license to a **source-available** license, such as the Business Source License (BSL) or the Server Side Public License (SSPL). The source can be read, but the license limits use, for example by forbidding a competing hosted service. These are not open source by the Open Source Definition. The change of a project's license is a risk for users and the reason that several communities made forks under a foundation.

## Contributions and the license

A contributor gives the project the right to use the contribution. Projects collect this through a **Contributor License Agreement (CLA)** or a **Developer Certificate of Origin (DCO)** sign-off, where the contributor states that they have the right to submit the change. Kubernetes uses the CLA of the CNCF.

## Dual licensing and compatibility

Licenses can conflict. Apache 2.0 code can go into a GPL version 3 project, but GPL version 2 only code cannot be combined with Apache 2.0. A check of compatibility belongs in the dependency review. Tools scan a project for license identifiers (SPDX identifiers such as `Apache-2.0`) and list them in a software bill of materials.

## Record the license of a dependency

Write the license and the source next to the workload that uses it, and read them back:

<!-- astrona:playground:renew -->

```sh
kubectl -n starfleet annotate deployment scout license=Apache-2.0 source=github.com/stefanprodan/podinfo --overwrite
kubectl -n starfleet get deployment scout -o jsonpath='{.metadata.annotations.license}{"\n"}'
```

Remove the annotations with `kubectl -n starfleet annotate deployment scout license- source-`.

## Common pitfalls

> [!WARNING]
> - **Reading open source as free of conditions.** Every license has some.
> - **Fearing all copyleft.** Internal use of GPL software does not require publishing your code.
> - **Missing the AGPL network clause.** Offering a modified version as a service triggers it.
> - **Treating a source-available license as open source.** Use may be restricted.
