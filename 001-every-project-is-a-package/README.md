## Python package management

[Python](https://www.python.org/) is the scripting language we use the most in our projects. It's a tried-and-true language with an active community and a robust ecosystem of libraries, tools, and packages across innumerable domains. While we'll use Python in many of our examples, in many cases some of the ideas could be useful in other contexts.

[pip](https://pip.pypa.io/en/stable/), the Package Installer for Python, has been the de facto Python package management tool for the last decade. With it came the simple [requirements.txt](https://pip.pypa.io/en/stable/reference/requirements-file-format/) file format for specifying a project's dependencies, making it easier to ensure consistent development environments and builds for Python projects. Some of us are ancient enough to remember the "before time," when we used easy_install and other far less convenient methods to install and manage Python dependencies for our projects.

```ini 001-every-project-is-a-package/manifest-examples/requirements.txt
# Simple requirements.txt.
fastrandom==0.1.0
```

pip has been a huge quality-of-life improvement and it still gets the job done a decade later. But pip and, more importantly the `requirements.txt` format, are relatively limited when stacked up against other modern language ecosystems and their respective package managers. Let's see why.

## Package management = Dependency management + Package distribution

Taking a simplified view of package management, we can break up the responsibilities into 2 buckets, or 2 sides of the same coin:

1. Consumption of packages (dependency management): allowing you to provide metadata describing how your project should be built, during development and for deployment. Most importantly, this includes articulating your project's package dependencies and making their installation straightforward.
1. Distribution of packages (publishing): allowing you to provide metadata describing what your project does, how, and why for the purposes of distribution. This includes properties such as name, description, version, and authors. It also includes making the publishing of your project as a package straightforward.

The majority of developers will interact often with Number 1 for their project and less often with Number 2, unless they're creating or contributing to open source projects. pip handles consumption of distributed packages and installation of a package's dependencies but does not directly handle packaging and distribution responsibilities. `requirements.txt` only really handles the dependency articulation piece of the equation.

## Modern package management: Every project **is** a package.

Language ecosystems that have come of age more recently have had the benefit of seeing what came before them, giving them some helpful insights. Some of these insights relate to package management and Python's history in that area has undoubtedly had some impact.

A common pattern with these new kids on the block is combining both aspects of package management into a single tool and file format, a manifest that contains all of the metadata relevant to your project for build and distribution, dependencies included. This greatly simplifies package management. [Cargo.toml](https://doc.rust-lang.org/cargo/reference/manifest.html) used by Cargo for Rust (get it? cargo manifest, haha) and [package.json](https://docs.npmjs.com/cli/v8/configuring-npm/package-json) used by NPM and Yarn for JavaScript / TypeScript are two examples of combined manifest files in popular language ecosystems.

```toml 001-every-project-is-a-package/manifest-examples/Cargo.toml
[package]
authors = ["Randy J <randy@astruct.co>"]
description = "Simple Rust manifest example."
edition = "2021"
name = "rust-example"
version = "0.1.0"

[dependencies]
rand = "0.8.5"
```

```json 001-every-project-is-a-package/manifest-examples/package.json
{
  "private": true,
  "name": "@randy/package-json-example",
  "description": "Simple JS manifest example.",
  "version": "0.1.0",
  "author": {
    "name": "Randy J",
    "email": "randy@astruct.co"
  },
  "engines": {
    "node": "17.0.0",
    "npm": "8.0.0"
  },
  "dependencies": {
    "random": "3.0.6"
  }
}
```

These file formats are used even if you never intend your project be distributed as a package. Every project becomes a package, whether distributed or not.

## Enter pyproject.toml

Having taught many old tricks to new dogs, the Python community has not shied away from picking up new tricks from their new dog peers. Similar to the above-mentioned formats, the emerging `pyproject.toml` format intends to be the single format across package management for Python. The format uses [TOML](https://toml.io/en/), a minimal and and more readable language for configuration files, making it a closer cousin to Rust's `Cargo.toml` than JS's `package.json`.

First suggested in [PEP 518](https://peps.python.org/pep-0518/) and expanded upon in subsequent PEPs, the primary motivation for `pyproject.toml` was to replace the aging `setup.py` / `setup.cfg` manifest formats used for package distribution as defined by `setuptools` and `distutils` before it. Beginning with the adoption of [PEP 621](https://peps.python.org/pep-0621/), `pyproject.toml` has become the [standard format](https://packaging.python.org/en/latest/specifications/declaring-project-metadata/) for specifying a project's metadata going forward and both [setuptools](https://setuptools.pypa.io/en/latest/userguide/pyproject_config.html) and [pip](https://pip.pypa.io/en/stable/reference/build-system/pyproject-toml/) now "speak" this format.

## pyproject.toml for humans

Just as other language ecosystems have discovered, treating every project as a package greatly simplifies package management. Multiple package managers have come to the rescue by either adding support for `pyproject.toml` or using it "natively" from day one in the case of recent entrants. Most of them still use pip to some degree under the hood. Some of these package managers are more focused on distribution than others.

Below are some of these package managers, in alphabetical order, along with example `pyproject.toml` manifest files:

- [Flit](https://github.com/pypa/flit)
- [Hatch](https://hatch.pypa.io/)
- [PDM](https://pdm.fming.dev/)
- [Poetry](https://python-poetry.org/)
- [PyFlow](https://github.com/David-OConnor/pyflow)

```toml 001-every-project-is-a-package/manifest-examples/pyproject.toml
[project]
authors = [{name = "Randy J", email = "randy@astruct.co"}]
description = "Simple manifest example."
name = "pytproject-example"
requires-python = "3.10"
version = "0.1.0"

dependencies = [
    "fastrandom==0.1.0",
]
```

```toml 001-every-project-is-a-package/manifest-examples/flit.pyproject.toml
[build-system]
requires = ["flit_core >=3.2,<4"]
build-backend = "flit_core.buildapi"

[project]
authors = [{name = "Randy J", email = "randy@astruct.co"}]
description = "Simple Flit manifest example."
name = "flit-example"
requires-python = "3.10"
version = "0.1.0"

dependencies = [
    "fastrandom==0.1.0",
]
```

```toml 001-every-project-is-a-package/manifest-examples/hatch.pyproject.toml
[build-system]
requires = ["hatchling>=1.11.0"]
build-backend = "hatchling.build"

[project]
authors = [{name = "Randy J", email = "randy@astruct.co"}]
description = "Simple Hatch manifest example."
name = "hatch-example"
requires-python = "3.10"
version = "0.1.0"

dependencies = [
    "fastrandom==0.1.0",
]
```

```toml 001-every-project-is-a-package/manifest-examples/poetry.pyproject.toml
[tool.poetry]
authors = ["Randy J <randy@astruct.co>",]
description = "Simple Poetry manifest example."
name = "poetry-example"
version = "0.1.0"

[build-system]
build-backend = "poetry.core.masonry.api"
requires = ["poetry-core>=1.0.0"]

[tool.poetry.dependencies]
fastrandom = "0.1.0"
python = "^3.10"
```

```toml 001-every-project-is-a-package/manifest-examples/pyflow.pyproject.toml
[tool.pyflow]
authors = ["Randy J <randy@astruct.co>"]
description = "Simple PyFlow manifest example."
name = "pyflow-example"
py_version = "3.10"
version = "0.1.0"

[tool.pyflow.dependencies]
fastrandom = "0.1.0"
```

It's worth noting that `pyproject.toml`, while now a standard, is flexible and in flux. You'll notice the manifest files look similar, in some cases practically identical with the exception of specifying which tool and version should be used in the `build-system` section. But they're not identical, with manifests looking more like "dialects" of a shared language. Still, migrating between them wouldn't be a huge undertaking as the main building blocks are fairly consistent across.

There are a few other package managers worth mentioning:

- [pip-tools](https://github.com/jazzband/pip-tools/)
- [Pipenv](https://pipenv.pypa.io/)

pip-tools doesn't present itself as a package manager but instead as a collection of command line "convenience" tools. It allows you to compile your `requirements.txt` file from other formats, including `pyproject.toml`. pip-tools sticks with the old standard but uses it almost as a simple lock file compiled from the new standard.

Pipenv uses TOML but uses its own specification, the [Pipfile](https://pipenv-fork.readthedocs.io/en/latest/basics.html#example-pipfile-pipfile-lock). It's important to note that while Pipenv brings a lot of the same benefits as the above tools with respect to package management, it doesn't directly provide any distribution related functionality:

```toml 001-every-project-is-a-package/manifest-examples/Pipfile
[[source]]
name = "pypi"
url = "https://pypi.org/simple"
verify_ssl = true

[packages]
fastrandom = "0.1.0"

[requires]
python_version = "3.10"
```

Time will tell whether one will become the de facto package manager and be absorbed into [The Python Standard Library](https://docs.python.org/3/library/) or if they will continue to coexist long-term as NPM and Yarn continue to do. The standard manifest format should make coexistence easier.

Some of the projects fall under the umbrella of the [Python Packaging Authority](https://www.pypa.io/)'s, namely Flit, Hatch, and Pipenv, so these may have a higher likelihood of being absorbed into the standard library. That said, Poetry currently appears to be the most popular of the bunch `pyproject.toml`. Judging by GitHub stars (~22k stars vs ~1 to 6k for the others) and development activity, it has a clear lead rivaled only by Pipenv in this regard.

## Choosing a package manager for our new projects

We knew for certain that we wanted to switch away from using pip and `requirements.txt` directly for our projects going forward. Because we buy in to the "every project is a package" methodology but also for the purpose of trying new tools. Existing comparisons and benchmarks are always helpful but, as these tools are evolving and in flux, this information becomes stale quickly. All of these tools provide similar features when compared to each other and also

package managers from other ecosystems. We kept the decision simple and went with Poetry for a handful reasons:

- Pipenv doesn't yet use the new `pyproject.toml` standard so it wasn't on the table, as far as we're concerned.
- Poetry appears to be more "for humans" while many of the others appear more focused on the super-humans who actually distribute packages..
- Poetry appears to have the most activity. Seemed like a safe choice that won't be abandoned any time soon.
- Poetry's extensibility through its plugin architecture holds some interesting future potential.
- The road map leading the 1.2.0 release of Poetry, now officially released, contained several compelling new features including optional dependency groups.

As mentioned before, migrating between tools shouldn't be a heavy lift given the same / similar manifest format so this doesn't feel like an irreversible commitment. We'll be providing some Poetry-based examples in some subsequent posts and highlight any pitfalls and learnings that we encounter along the way. If you're considering a switch, hopefully you've found some of this information useful. Of course, you should switch to the tool(s) that make sense for you don't be afraid to experiment.

**All code referenced in this post can be found [here](https://github.com/Analogous-Structures-Labs/astruct-blog-examples/tree/main/001-every-project-is-a-package/).**
