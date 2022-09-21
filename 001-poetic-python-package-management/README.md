# Introduction and first topic: Trying Poetry

Hello, random person who somehow stumbld across this blog. We created this blog as a place to share simple concepts we've played around with during development of some of our projects, generlized and simplified for easy consumption. In most cases, these ideas have come up while working with tools that are new to us or new features of tools we have used before. In some cases, we weren't able to find clear examples that answered our questions so we created our own and are sharing them here.

Some of the articles will build on previous articles. All of he code for the examples will be available in a public GitHub repo, to which we will link. Feel free to engage, comment, ask questions, hurl insults, etc. We're not married nor religious about any one way of doing things nor any of the examples.

## What this blog is

Random musings, experiments and examples that are possibly helpful to others doing software product development.

## What this blog isn't

Perfect, authoritative, nor supported software.

By way of disclaimer, we make no warrants or guarantees regarding these code examples. You're free to use them, in whole or in part, if you feel they'd be useful to you in something you are building. But they are essentially presented as toys. There are no guarantees that anything in the examples is the best practice, best solution, or even a good solution. We don't purport to be experts in all (or even any) of the technologies utilized herein. In fact, there are clear areas where we take shortucts for the sake of simplicity or brevity and we'll attempt to call those out. It's best to think of these as isolated proofs of concept that answer the feasibility of a very specific idea without officially opining on the idea's quality, viability, nor its desirability as a solution.

## Python projects

We use Python for many if not most of our projects that call for rapid development in an interpreted language. It's a tried-and-true language with an active community and a robust ecosystem of libraries, tools, and packages across many domains. Many of our examples will build upon a theoretical project written in Python but the ideas will likely be applicable in other ecosystems.

## Python package management

[Pip](https://pip.pypa.io/en/stable/), the Package Installer for Python, has been the de facto Python package management tool for the last decade. With it came the simple [requirements.txt](https://pip.pypa.io/en/stable/reference/requirements-file-format/) file format for specifying a project's dependencies, making it easier to define and install all of a project's (Python) dependencies. Some of us are ancient enough to remember the before time, when we used easy_install and other far less convenient methods to install and manage Python dependencies for our projects.

Pip has been a huge quality of life improvement and it still gets the job done a decade later. But pip and, more importantly the requirements.txt format, are relatively limited when stacked up against other modern language ecosystems and their respective package managers.

## Package management = Dependency management + Package distribution

Taking a simplified view of package management, we can break up the responsibilities into 2 buckets:

- Dependency management: making it easy to articulate upon which packages your project depends and making it easy to install said dependencies.
- Package distribution: making it easy to articulate details of what your project does and how and facilitating packaging it, making it ready for distrubtion either by publishing the package to an index or via some other means.

The majority of developers will interact often with dependency management and less often with package distribution unless they're creating or contibuting to open source projects. Pip handles consumption of distributed packages but does not directly handle and distribution responsibilities. Requirements.txt only really handles the dependency management piece.

## Modern package management: Every project is a package.

Language ecosystems that have come of age more recently have had the benefit of seeing what came before them, giving them some helpful insights. Some of these insights relate to package management and Python's history in that realm undoubtedly had some impact.

A common pattern with these new kids on the block is combining both aspects of package management into a single tool and file format, a sort of manifest that contains all of the metadata relevent to your project for build and distribution, dependencies included. This greatly simplifies package management. [Cargo.toml](https://doc.rust-lang.org/cargo/reference/manifest.html) used by Cargo for Rust and [package.json](https://docs.npmjs.com/cli/v8/configuring-npm/package-json) used by NPM and Yarn for JavaScript are two examples of combined manifest file formats.

These formats are used even if your project will never be distributed. They solve for packaging but also package management while building. Every project becomes a package, whether distributed or not.

## Enter pyproject.toml

Having taught many old tricks to new dogs, the Python community has not shied away from picking up new tricks from their new dog peers. Similar to the above mentioned formats, the emerging pyproject.toml format intends to be the single format across package management for Python. The format uses [TOML](https://toml.io/en/), a minimal and and more readable language for configuration files, making it more similar to Rust's Cargo.toml than JS's package.json.

First suggested in [PEP 518](https://peps.python.org/pep-0518/) and expanded upon in subsequent PEPs, the primary motivation for pyproject.toml was to replace the aging setup.py manifest format used in packages as defined by setuptools and distutils before it. Beginning with [PEP 621](https://peps.python.org/pep-0621/), pyproject.toml has become the [standard format](https://packaging.python.org/en/latest/specifications/declaring-project-metadata/) for specifying a package's metadata and both [setuptools](https://setuptools.pypa.io/en/latest/userguide/pyproject_config.html) and [pip](https://pip.pypa.io/en/stable/reference/build-system/pyproject-toml/) now "speak" this format.

## pyproject.toml for humans

Just as other language ecosystems have discovered, treating every project as a package greatly simplifies package management. Multiple package managers have come along to replace pip and requirements.txt with tooling around the pyproject.toml format, although they typically use pip under the hood, at least for now (alphabetical order, not a reflection of any):

- [Hatch](https://hatch.pypa.io/)
- [PDM](https://pdm.fming.dev/)
- [pip-tools](https://github.com/jazzband/pip-tools/)
- [Poetry](https://python-poetry.org/)
- [pyflow](https://github.com/David-OConnor/pyflow)

It remains unclear whether one will become the de facto package manager or whether they will continue to coexist. The standard format should make coexistence easier, with teamwith the standard format making it easy to choose your preference and move between them as desired. Poetry has a clear lead based on GitHub stars, ~22k vs ~1-3k for each of the others, as of this writing, and other visible activity. Hatch is a bit of a resurrected project, technically starting development in 2017 but hitting its 1.0 release only this past April. It might have an eventual advantage as a result of being a project under the [Python Packaging Authority](https://www.pypa.io/). We ourselves are keeping an eye on all the players as they evolve and add new features.
pypa.io/).


recent entry in to the space have come along as pyproject.toml-based package managers that can be used for development without necessitating distribution.


It's worth mentioning [Pipenv](https://pipenv.pypa.io/), another popular package management project also under the PyPa authority. Like the others, it uses TOML but uses its [own specification](https://pipenv-fork.readthedocs.io/en/latest/basics.html#example-pipfile-pipfile-lock) and not the now standard pyproject.toml. As of this writing, its GitHub stars are comparable to Poetry's.

All of these tools provide the niceties common in modern package management including ease of dependency specification & installation, predictable deterministic builds recorded in a lock file, separation of core versus dev dependencies, support for virtual environments, and ease of package build & distribution.

It's worth noting that pyproject.toml while now a standard is an evolving standard. At the moment, manifest files will look similar but not identical across these tools, looking more like "dialects" of a shared language. Moving between them shouldn't be too challenging but hopefully the dialects converge over time as the standard is further codified and more PEPs pop up.

## Choosing a package manager for our new projects

We knew for certain that we wanted to switch away from using pip and requirements.txt directly for our new projects. Partly because we believe in the "every project is a package" mentality. But, also for the purpose of experimenting with new tools. Existing comparisons and benchmarks are always helpful but, as these tools are evolving and in great flux, this information becomes stale quickly.

We kept the decision simple and went with Poetry for a handful of arguably qualitative reasons:

- Pipenv was out as we wanted to stick with a tool using the new pyproject.toml standard.
- Poetry appears to be the most active / popular / mature of the other tools based on a number of metrics visible in its GitHub repo.
- The roadmap targetting the 1.2.0 release of Poetry, now officially released, contained several compelling new features including optional dependency groups and finer grained control over dependency installation.
- Extensibility through their plugin architecture holds some interesting future potential.

As mentioned before, a migration between tools shouldn't be a heavy lift given the same / similar manifest format. For that reason, we didn't feel like we were making an irreversible commitment and felt comfortable moving forward with Poetry.

## A Common Scenario: dependencies vs. dev dependencies

As a starting point, our first toe in the water with Poetry was leveraging one of the more universal features of modern package managers, one that requirements.txt doesn't make easy: installing dev dependencies only on environments where they're needed. Or, converesely, not installing dev dependencies in production.

Typically, we've handled this for Python projects by having 2 different requirements.txt files: one with core dependencies which we need in all environments and a second with only our dev dependencies which we only want on dev environments such as local workstations and unstable test environments.

We generally use Docker for client-server scenarios, especially web. Bellow is an example of how we would handle separate images for dev and production and selectively installing dev dependencies:

```dockerfile:001-poetic-python-package-management/pipapp/Dockerfile
# syntax=docker/dockerfile:1.4
ARG APP_DIR=/app
ARG HTTP_PORT=80

# Alias our base image so we don't have to repeat the version number.
FROM python:3.10.6-alpine3.16 AS python

ENV \
    # We'll let Dependabot keep our python base image up-to-date.
    # This should ensure a pretty recent pip
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    # Don't warn about running pip as root.
    PIP_ROOT_USER_ACTION=ignore \
    # Don't buffer python output to stdout or stderr.
    # We want to see what our app is doing live in case of a crash before the buffer gets flushed.
    PYTHONUNBUFFERED=1


FROM python AS app

ARG APP_DIR
ARG HTTP_PORT

ENV \
    HTTP_PORT=$HTTP_PORT \
    BIND_ADDRESS=0.0.0.0:$HTTP_PORT

WORKDIR /tmp

# Install pip managed dependenices.
COPY requirements/requirements.txt requirements.txt
RUN apk add --no-cache --update --virtual build-dependencies \
    # General build dependencies.
    build-base \
    # Build dependencies required by specific python packages.
    postgresql-dev \
    && \
    # Install dependenices managed via pip.
    pip install --no-cache --no-compile --no-input -r requirements.txt && \
    # Remove build dependencies.
    apk del --purge build-dependencies && \
    rm requirements.txt

RUN apk add --no-cache --update \
    # Runtime dependencies.
    libpq

COPY ./src $APP_DIR/src/

WORKDIR $APP_DIR/src

EXPOSE $HTTP_PORT

HEALTHCHECK --interval=60s --timeout=5s \
        CMD wget --no-cache --spider http://$BIND_ADDRESS/health-check

ENTRYPOINT hypercorn \
           --bind $BIND_ADDRESS \
           --access-logfile - \
           --log-file - \
           --worker-class uvloop \
           --workers 4 \
           main:app


FROM app AS devapp

ENV \
    # Prevent python from writing bytecode during development.
    PYTHONDONTWRITEBYTECODE=1

# Install pip managed DEV dependenices.
COPY requirements/requirements.dev.txt requirements.txt
RUN apk add --no-cache --update --virtual build-dependencies \
    # General build dependencies.
    build-base \
    && \
    pip install --no-cache --no-compile --no-input -r requirements.txt && \
    # Remove build dependencies.
    apk del --purge build-dependencies && \
    rm requirements.txt

WORKDIR $APP_DIR/src

# Override our entrypoint with more appropriate settings for development.
ENTRYPOINT hypercorn \
           --bind $BIND_ADDRESS \
           --access-logfile - \
           --log-file - \
           --worker-class uvloop \
           --workers 1 \
           --log-level debug \
           --reload \
           main:app

```
## Beyond
