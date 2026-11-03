---
draft: true
exam_objectives:
  - Cloud Native Community and Collaboration
---
# The Code Of Conduct And Taking Part

An open source community works only if people can take part safely. This part covers the Code of Conduct, the channels of the community and the ways to start contributing.

## The Code of Conduct

The CNCF has a **Code of Conduct** based on the Contributor Covenant. It applies to all CNCF projects, to their spaces such as repositories, chats and meetings, and to the CNCF events. In short it asks every participant to:

- Be respectful and welcoming, and use inclusive language.
- Accept constructive feedback gracefully.
- Focus on what is best for the community.
- Avoid harassment, personal attacks and discriminatory behavior.

Unacceptable behavior can be reported to the Code of Conduct Committee, which investigates in confidence. The consequences range from a warning to a ban from the community. Kubernetes has its own committee for its spaces.

## Ways to contribute

Contribution is not limited to code. All of these help a project:

- **Documentation.** Fix an error, add an example or translate a page. SIG Docs has a clear process, and the "good first issue" label marks tasks for new contributors.
- **Issues.** A reproducible bug report with the version and the steps.
- **Reviews.** Reading and testing the pull request of someone else.
- **Testing.** Run release candidates and report problems.
- **Answering questions.** Help other users in the Slack channels and forums.
- **Organizing.** Run a local meetup or a Kubernetes Community Days event.

## Where the community talks

- **Slack.** The Kubernetes Slack workspace has a channel per SIG and per topic. The channel `#kubernetes-novice` and `#sig-contribex` help new contributors.
- **Mailing lists and Discuss.** Used for announcements and longer discussions.
- **Community meetings.** Public video calls of SIGs, with notes and recordings.
- **GitHub.** Repositories under the `kubernetes` organization hold the code, issues and KEPs.

## Starting as a contributor

1. Read the contributor guide of the project and the Code of Conduct.
2. Sign the contributor license agreement or the Developer Certificate of Origin, as the project requires.
3. Pick a small task, such as a documentation fix, and read its issue.
4. Join the meeting or the channel of the SIG that owns it.
5. Open a focused pull request and respond to review comments.

## The Kubernetes Contributor Summit and events

KubeCon + CloudNativeCon is the main event of the CNCF. It has a Contributor Summit for people who work on the projects. Local Kubernetes Community Days events and CNCF meetups give a lower entry point. The **CNCF Ambassadors** are community members who teach and help others.

## Record who owns a service

Open source teams write down ownership, and so should your services. Label the playground application with the group that owns it and the channel to ask:

<!-- astrona:playground:renew -->

```sh
kubectl -n starfleet annotate deployment scout owner-sig=sig-apps contact-channel=bridge-ops --overwrite
kubectl -n starfleet get deployment scout -o jsonpath='{.metadata.annotations}'
```

Remove the annotations with `kubectl -n starfleet annotate deployment scout owner-sig- contact-channel-`.

## Common pitfalls

> [!WARNING]
> - **Thinking only code counts.** Documentation, issues and reviews count.
> - **Opening a large pull request in a first contribution.** Start small.
> - **Posting a security issue in a public issue.** Use the project's private security process.
> - **Ignoring the review comments.** Contributors who respond become maintainers.
