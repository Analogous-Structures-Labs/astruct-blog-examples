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

## A Common Scenario: dependencies vs. dev dependencies

As a starting point, our first toe in the water with Poetry was leveraging one of the more universal features of modern package managers, one that requirements.txt doesn't make easy: installing dev dependencies only on environments where they're needed. Or, conversely, not installing dev dependencies in production.

Typically, we've handled this for Python projects by having 2 different requirements.txt files: one with universal dependencies which are needed on all environments and a second with only our dev dependencies which we only want on dev environments where we're building, testing, debugging.

We generally use Docker for client-server scenarios, especially web. Bellow is an example Dockerfile showing how we would typically handle separate images for dev and production and selectively installing dev dependencies.

Yes, we're using alpine base images and no we don't want to argue about it! We're aware of the lack of official pre-built wheels for alpine and other musl-based distributions and the additional hoops we have to jump through when using alpine. Hopefully, some hero comes along and champions the creation of musl wheels the way someone once did for glibc-based distros. We may cover this in a separate post and explain the what and why for those who aren't aware and cover some heroic projects looking to solve this.

```dockerfile 001-poetic-python-package-management/pipapp/Dockerfile
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

# In practice, we'd probably want to use the CMD form and / or a wrapper shell script to specify our
# entrypoints and healthchecks. For the sake of simplicity and having fewer files, we're using the shell form.
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

As stated, we have 2 requirements files: one with our universal dependencies, installed in our `app` image, and a second with our dev dependencies. The second requirements file is installed only in our `devapp` image which derives from `app`, installs the additional dependencies, and then runs a slightly altered entrypoint that enables debug output and live reloading. Nothing wrong with this approach. It works and if you're working with Python and Docker, you've probably seen this pattern before.

Universal requirements:
```ini 001-poetic-python-package-management/pipapp/requirements/requirements.txt
# Keep alphabetized.
fastapi==0.82.1
hypercorn==0.14.3
psycopg2==2.9.3
sqlalchemy==1.4.40
uvloop==0.16.0
```

Dev requirements:
```ini 001-poetic-python-package-management/pipapp/requirements/requirements.dev.txt
# Keep alphabetized.
isort==5.10.1
mypy==0.971
pylint==2.15.0
pytest==7.1.3
```

Now let's accomplish the same exact outcome using Poetry:

```dockerfile 001-poetic-python-package-management/poetryapp/Dockerfile
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
    BIND_ADDRESS=0.0.0.0:$HTTP_PORT \
    # We have to set this as poetry doesn't have a equivalent passthrough argument.
    PIP_COMPILE=0

WORKDIR /tmp

# Install pip managed dependenices.
COPY requirements/requirements.txt requirements.txt
RUN apk add --no-cache --update --virtual build-dependencies \
    # General build dependencies.
    build-base \
    && \
    # Install dependenices managed via pip.
    pip install --no-cache --no-compile --no-input -r requirements.txt && \
    # Remove build dependencies.
    apk del --purge build-dependencies && \
    rm requirements.txt && \
    # Configure poetry.
    poetry config virtualenvs.create false

# Install poetry managed dependencies.
COPY requirements/pyproject.toml pyproject.toml
RUN apk add --no-cache --update --virtual build-dependencies \
    # General build dependencies.
    build-base \
    # Build dependencies required by specific python packages.
    postgresql-dev \
    && \
    poetry install --no-cache --no-interaction --without dev && \
    apk del --purge build-dependencies

RUN apk add --no-cache --update \
    # Runtime dependencies.
    libpq

COPY ./src $APP_DIR/src/

WORKDIR $APP_DIR/src

EXPOSE $HTTP_PORT

HEALTHCHECK --interval=60s --timeout=5s \
        CMD wget --no-cache --spider http://$BIND_ADDRESS/health-check

# In practice, we'd probably want to use the CMD form and / or a wrapper shell script to specify our
# entrypoints and healthchecks. For the sake of simplicity and having fewer files, we're using the shell form.
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

WORKDIR /tmp

# Install poetry DEV managed dependencies.
RUN apk add --no-cache --update --virtual build-dependencies \
    # General build dependencies.
    build-base \
    && \
    poetry install --no-cache --no-interaction --only dev && \
    # Remove build dependencies.
    apk del --purge build-dependencies

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

Okay okay, I know what you're thinking. This is arguably worse. We're jumping through extra hoops. We have extra configuration steps and we still have 2 files and one of them is still a requirements.txt file:

```dockerfile 001-poetic-python-package-management/poetryapp/Dockerfile[32-44]
# Install pip managed dependenices.
COPY requirements/requirements.txt requirements.txt
RUN apk add --no-cache --update --virtual build-dependencies \
    # General build dependencies.
    build-base \
    && \
    # Install dependenices managed via pip.
    pip install --no-cache --no-compile --no-input -r requirements.txt && \
    # Remove build dependencies.
    apk del --purge build-dependencies && \
    rm requirements.txt && \
    # Configure poetry.
    poetry config virtualenvs.create false
```

Give us a chance to explain. Yes we have to files but the 2 files serve different purposes than our 2 files in the pip example. We have to install poetry. Now, we could do this inline in our Dockerfile by running any of the following mostly equivalent commands:

```sh
pip install poetry
pip install poetry==1.2.0
curl -sSL https://install.python-poetry.org | python3 -
curl -sSL https://install.python-poetry.org | POETRY_PREVIEW=1.2.0 python3 -
```

The 4th option is arguably the best of the bunch and better than our approach as its closer to how both Python and Pip are installed in the official images.

So why do we install Poetry via a separate requirements.txt file? We do it so that [Dependabot](https://github.com/dependabot) can keep our version of Poetry up-to-date. If you're unfamiliar with Dependabot, it's a... bot that monitors your project's dependencies, checks for updated versions on the corresponding package indexes, and updates the dependency in a branches / pull request. You can either manually review the PR or if you have a good CI setup with good tests, your CI will tell you whether the update can be safely merged in. It can monitor [many different languages and package managers](https://docs.github.com/en/code-security/dependabot/dependabot-version-updates/about-dependabot-version-updates) including Pip, Poetry's flavor of pyproject.toml (another point for Poetry), Pipenv, and even Dockerfiles. We use it in our projects to monitor everything we possibly can. While it can monitor Python dependencies and Dockerfiles, it won't monitor Python dependencies specified inline in a Dockerfile, even if you specify a pinned version. For that reason, we maintain a requirements.txt file that installs Poetry and only Poetry.

```ini 001-poetic-python-package-management/poetryapp/requirements/requirements.txt
# This file only exists to install packages needed to bootstrap before handing things off to poetry.
# All other packages should be added to pyproject.toml in this same directory.
# Keep alphabetized.
poetry==1.2.0
```

If you aren't using Dependabot, you should really take a look at it. It's now integrated into GitHub and free. We may further sing its praises in a future post. You can choose to replace our 2-file approach with one of the above inline option with the rest of the build working as expected. Let's move on.

If we take a look at our pyproject.toml, we can instantly see some of the quality-of-life benefits:

```toml 001-poetic-python-package-management/poetryapp/requirements/pyproject.toml
[tool.poetry]
authors = [
    "Randy J <randy@astruct.co>",
]
description = "Simple example of using poetry to create a separate dev image in Docker."
name = "poetry-example"
version = "0.1.0"

[build-system]
build-backend = "poetry.core.masonry.api"
requires = [
    "poetry-core>=1.0.0",
]

# Keep each group alphabetized.

[tool.poetry.dependencies]
fastapi = "0.82.0"
hypercorn = "0.14.3"
python = "^3.10"
sqlalchemy = "1.4.40"
uvloop = "0.16.0"


[tool.poetry.dev-dependencies]
isort = "5.10.1"
mypy = "0.971"
pylint = "2.15.0"
pytest = "7.1.3"
```

We have more information about our project than requirements.txt allows. We have a clear separation between our universal dependencies and our dev dependencies in one file. We can install them selectively using Poetry's [--with, --without, and --only](https://python-poetry.org/docs/cli/#install) command line options (new as of version 1.2.0):

```dockerfile 001-poetic-python-package-management/poetryapp/Dockerfile[54-54]
    poetry install --no-cache --no-interaction --without dev && \
```

```dockerfile 001-poetic-python-package-management/poetryapp/Dockerfile[94-94]
    poetry install --no-cache --no-interaction --only dev && \
```

Easy to read. Easy to modify. Difficult to mess up.

Now, what did we really improve? We're jumping through some extra hoops. We have the same number of files. Was it worth it? You shouldn't have to mess with the hoops once you have everything working. Once Poetry, or one of the other new package managers, becomes official, these hoops will likely disappear into the lower-level base Python images. Or maybe the Poetry project will start maintaining Docker images with Poetry pre-installed to facilitate and encourage adoption. We'll let you decide whether it makes sense for your projects and provides you value or convenience. We're going to keep playing with it and keep an eye on how things develop.

Hopefully, this post made it easier for you to consider Poetry and give it a try.

Until next time, keep trying new things.

**All code referenced in this post can be found [here](https://github.com/Analogous-Structures-Labs/astruct-blog-examples/tree/blog/001-adding-article-content/001-poetic-python-package-management).**
