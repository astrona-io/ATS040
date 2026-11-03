# Get Your Machine Ready

You need a Markdown reader or the Astrona reading interface. A browser can display the repository pages. The course uses Mermaid diagrams, a text format that the reading interface turns into drawings. If your reader does not display a diagram, the surrounding prose still explains its mechanism.

The playgrounds and labs run on your own computer. You need the `astrona` command-line tool, a container engine that kind can use (Podman or Docker) with about 2 GiB of free memory, `kubectl` and `jq`. Run `astrona check` to see whether the tool and the engine work. Each environment is a single-node kind cluster with Kubernetes 1.35, and `astrona destroy` removes it when you finish.

Use a notebook to record unfamiliar terms and your reasoning for each practice answer. When a page is missing, check that you are viewing the content branch or published revision that contains this draft. If a diagram or reading fails to load, record the page title and the visible error when reporting the issue.
