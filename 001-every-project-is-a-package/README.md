## Python projects

Python is probably the scripting language we use the most. It's a tried-and-true language with an active community and a robust ecosystem of libraries, tools, and packages across many domains. Many of our examples will build upon a toy project written in Python but the ideas will likely be applicable in other ecosystems.

## Python package management

[Pip](https://pip.pypa.io/en/stable/), the Package Installer for Python, has been the de facto Python package management tool for the last decade. With it came the simple [requirements.txt](https://pip.pypa.io/en/stable/reference/requirements-file-format/) file format for specifying a project's dependencies, making it easier to define and install all of a project's Python dependencies. Some of us are ancient enough to remember the "before time," when we used easy_install and other far less convenient methods to install and manage Python dependencies for our projects.

Pip has been a huge quality-of-life improvement and it still gets the job done a decade later. But pip and, more importantly the requirements.txt format, are relatively limited when stacked up against other modern language ecosystems and their respective package managers. Let's see why.

## Package management = Dependency management + Package distribution

Taking a simplified view of package management, we can break up the responsibilities into 2 buckets, or 2 sides of the same coin:

1. Dependency management: making it easy to articulate which packages your project depends on and making it easy to install said dependencies.
1. Package distribution: making it easy to articulate details of what your project does and facilitating packaging it, making it ready for distribution either by publishing the package to an index like the ubiquitous [PyPI](https://pypi.org/) or via some other means. This relies on number 1 as Pip will need to know your package's dependencies when someone attempts to install it.

The majority of developers will interact often with dependency management for their project and less often with package distribution unless they're creating or contributing to open source projects. Pip handles consumption of distributed packages and dependency specification in package but does not directly handle packaging and distribution responsibilities. Requirements.txt only really handles the dependency management piece.

## Modern package management: Every project **is** a package.

Language ecosystems that have come of age more recently have had the benefit of seeing what came before them, giving them some helpful insights. Some of these insights relate to package management and Python's history in that realm undoubtedly had some impact.

A common pattern with these new kids on the block is combining both aspects of package management into a single tool and file format, a manifest that contains all of the metadata relevant to your project for build and distribution, dependencies included. This greatly simplifies package management. [Cargo.toml](https://doc.rust-lang.org/cargo/reference/manifest.html) used by Cargo for Rust and [package.json](https://docs.npmjs.com/cli/v8/configuring-npm/package-json) used by NPM and Yarn for JavaScript are two examples of combined manifest file.

These formats are used even if your project will never be distributed as a package. They solve for packaging but also package management while building. Every project becomes a package, whether distributed or not.

## Enter pyproject.toml

Having taught many old tricks to new dogs, the Python community has not shied away from picking up new tricks from their new dog peers. Similar to the above-mentioned formats, the emerging pyproject.toml format intends to be the single format across package management for Python. The format uses [TOML](https://toml.io/en/), a minimal and and more readable language for configuration files, making it more similar to Rust's Cargo.toml than JS's package.json.

First suggested in [PEP 518](https://peps.python.org/pep-0518/) and expanded upon in subsequent PEPs, the primary motivation for pyproject.toml was to replace the aging setup.py / setup.cfg manifest formats used in packages as defined by setuptools and distutils before it. Beginning with [PEP 621](https://peps.python.org/pep-0621/), pyproject.toml has become the [standard format](https://packaging.python.org/en/latest/specifications/declaring-project-metadata/) for specifying a package's metadata going forward and both [setuptools](https://setuptools.pypa.io/en/latest/userguide/pyproject_config.html) and [pip](https://pip.pypa.io/en/stable/reference/build-system/pyproject-toml/) now understand this format.

## pyproject.toml for humans

Just as other language ecosystems have discovered, treating every project as a package greatly simplifies package management. Multiple package managers have come along to replace pip and requirements.txt with tooling around the pyproject.toml format, although they generally use pip under the hood, at least for now. Below are newer package managers that are pyproject.toml native, so to speak (alphabetical order, not a reflection of any preference):

- [Hatch](https://hatch.pypa.io/)
- [PDM](https://pdm.fming.dev/)
- [pip-tools](https://github.com/jazzband/pip-tools/)
- [Poetry](https://python-poetry.org/)
- [pyflow](https://github.com/David-OConnor/pyflow)

It remains unclear whether one will become the de facto package manager or whether they will continue to coexist as NPM and Yarn continue to do. The standard manifest format should make coexistence easier, with the standard format making it easy to choose your preference and move between them as desired. Poetry has a clear lead based on GitHub stars, ~22k vs ~1to 3k for each of the others, as of this writing, and other visible activity. Hatch is a bit of a resurrected project, technically starting development in 2017 but hitting its 1.0 release only this past April. It might have an eventual advantage as a result of being a project under the [Python Packaging Authority](https://www.pypa.io/). We're keeping an eye on all the players as they evolve and add new features.

It's worth mentioning [Pipenv](https://pipenv.pypa.io/), another popular package manager also under the PyPa authority. Like the others, it uses TOML but uses its [own specification](https://pipenv-fork.readthedocs.io/en/latest/basics.html#example-pipfile-pipfile-lock) and not the now standard pyproject.toml, at least not yet. As of this writing, its GitHub stars are comparable to Poetry's.

All of these tools provide the quality-of-life features common to other modern package management including ease of dependency specification & installation, predictable deterministic builds recorded in a lock file, separation of core versus dev dependencies, support for virtual environments, and ease of package build & distribution. They all create virtual environments by default so there is some configuration to do if you don't want / need a virtualenv, though YMMV when circumventing the virtual environment. There's arguably no reason to isolate your project within a virtual environment if you're already isolating it within a Docker container unless your container will be running multiple instances or multiple apps, which is probably ill-advised in any case.

It's worth noting that pyproject.toml, while now a standard, is an evolving standard and is subject to change and some interpretation. At the moment, manifest files will look similar but not identical across these tools, looking more like "dialects" of a shared language. Moving between them shouldn't be too challenging but hopefully the dialects converge over time as the standard is further codified and more PEPs pop up. The main building blocks are fairly consistent across.

## Choosing a package manager for our new projects

We knew for certain that we wanted to switch away from using pip and requirements.txt directly for our projects going forward. Partly because we believe in the "every project is a package" methodology. But, also for the purpose of trying new things. Existing comparisons and benchmarks are always helpful but, as these tools are evolving and in great flux, this information becomes stale quickly. We set out to decide for ourselves.

We kept the decision simple and went with Poetry for a handful reasons:

- Pipenv was out as we wanted to stick with a tool already using the new pyproject.toml standard.
- Poetry appears to be the most active / popular / mature of the other tools based on activity visible GitHub.
- Extensibility through their plugin architecture holds some interesting future potential.
- The road map targeting the 1.2.0 release of Poetry, now officially released, contained several compelling new features including optional dependency groups.

As mentioned before, a migration between tools shouldn't be a heavy lift given the same / similar manifest format. We didn't feel like we were making an lifetime commitment.
