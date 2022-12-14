## Getting poetic

In a [previous post](/001-every-project-is-a-package), we discussed the benefits of modern package managers and their every project is a package philosophy. Along with this, we covered the recent `pyproject.toml` standard for Python and the tools that are growing up around it. However, we didn't really dive into a concrete example that shows how your workflow might change if you were to switch from using just pip to one of these newer tools.

## A Common Scenario: Universal Dependencies vs. Dev Dependencies

One of the more common features of modern package managers, one that `requirements.txt` doesn't solve for, is installing dev dependencies only on environments where they're needed. Or, conversely, not installing dev dependencies in production. Typically, we've handled this for Python projects by having 2 different `requirements.txt` files: one with universal dependencies which are needed on all environments and a second with only our dev dependencies which we only want on dev environments where we're building, testing, debugging. Modern package managers, make this quite a bit cleaner.

For this example, we'll be using [Docker](https://www.docker.com/) and [Dockerfiles](https://docs.docker.com/engine/reference/builder/). Don't worry if you're not familiar with Docker, most of the commands are just good, old-fashioned Linux commands and should look familiar if you've been working with Linux and Python. Hopefully, you'll be able to follow along. All that said, if you're not using Docker or some form of containerization today, run don't walk to your [nearest Docker tutorial](https://docs.docker.com/get-started/).

Note: we're using alpine based images and no we don't want to argue about it! We're aware of the lack of official pre-built wheels for alpine and other non-glibc-based Linux distributions and the additional hoops we have to jump through when using alpine. We may cover this in a separate post and explain the what and why for those who aren't aware and cover some heroic projects looking to solve this. For now, let's not let that distract us from the subject at hand.

For the sake of brevity, we'll be including snippets our `Dockerfile` but we'll link to complete source code at the end of the post.

Install our Universal Dependencies:

```dockerfile 002-poetic-python-package-management/pipapp/Dockerfile [19:43]
FROM python AS app

ARG APP_DIR
ARG HTTP_PORT

ENV \
    HTTP_PORT=$HTTP_PORT \
    BIND_ADDRESS=0.0.0.0:$HTTP_PORT

WORKDIR /tmp

# Install pip managed dependencies.
COPY requirements/requirements.txt requirements.txt
RUN apk add --no-cache --update --virtual build-dependencies \
    # General build dependencies.
    build-base \
    # Build dependencies required by specific python packages.
    postgresql-dev \
    && \
    # Install dependencies managed via pip.
    pip install --no-cache --no-compile --no-input -r requirements.txt && \
    # Remove build dependencies.
    apk del --purge build-dependencies && \
    rm requirements.txt
```

Universal dependencies:

```ini 002-poetic-python-package-management/pipapp/requirements/requirements.txt
# Keep alphabetized.
fastapi==0.82.1
hypercorn==0.14.3
psycopg2==2.9.3
sqlalchemy==1.4.40
uvloop==0.16.0
```

Install our Dev dependencies:

```dockerfile 002-poetic-python-package-management/pipapp/Dockerfile [68:84]
FROM app AS devapp

ENV \
    # Prevent python from writing bytecode during development.
    PYTHONDONTWRITEBYTECODE=1

# Install pip managed DEV dependencies.
COPY requirements/requirements.dev.txt requirements.txt
RUN apk add --no-cache --update --virtual build-dependencies \
    # General build dependencies.
    build-base \
    && \
    pip install --no-cache --no-compile --no-input -r requirements.txt && \
    # Remove build dependencies.
    apk del --purge build-dependencies && \
    rm requirements.txt
```

Dev Dependencies:

```ini 002-poetic-python-package-management/pipapp/requirements/requirements.dev.txt
# Keep alphabetized.
isort==5.10.1
mypy==0.971
pylint==2.15.0
pytest==7.1.3
```

As mentioned previously, we have 2 requirements files: one with our universal dependencies, installed in our `app` image, and a second with our dev dependencies. The second requirements file is installed only in our `devapp` image which derives from `app`, installs the additional dependencies, and then runs a slightly altered entrypoint that enables debug output and live reloading. Nothing wrong with this approach. It works and if you've been working with Python for long, you've probably seen this pattern before.

Now let's accomplish the same outcome using Poetry:

```dockerfile 002-poetic-python-package-management/poetryapp/Dockerfile [19:56]
FROM python AS app

ARG APP_DIR
ARG HTTP_PORT

ENV \
    HTTP_PORT=$HTTP_PORT \
    BIND_ADDRESS=0.0.0.0:$HTTP_PORT \
    # We have to set this as poetry doesn't have a equivalent passthrough argument.
    PIP_COMPILE=0

WORKDIR /tmp

# Install pip managed dependencies.
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
```

```dockerfile 002-poetic-python-package-management/poetryapp/Dockerfile [81:97]
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
```

Okay okay, I know what you're thinking. This is arguably worse. We're jumping through extra hoops. We have extra configuration steps and we still have two files, one of them is still a `requirements.txt` file. Give us a chance to explain. Yes we have two files but the two files serve different purposes than our previous two files in the pip example. We have to install poetry. We maintain a `requirements.txt` file that installs Poetry and only Poetry:

```ini 002-poetic-python-package-management/poetryapp/requirements/requirements.txt
# This file only exists to install packages needed to bootstrap before handing things off to poetry.
# All other packages should be added to pyproject.toml in this same directory.
# Keep alphabetized.
poetry==1.2.0
```

We could do this inline in our Dockerfile by running any of the following mostly equivalent commands:

```sh
pip install poetry
pip install poetry==1.2.0
curl -sSL https://install.python-poetry.org | python3 -
curl -sSL https://install.python-poetry.org | POETRY_PREVIEW=1.2.0 python3 -
```

The 4th option is arguably the best of the bunch and better than our approach as its closer to how both Python and pip are installed in the official Python Docker images.

So why do we install Poetry via a separate `requirements.txt` file? We do it so that [Dependabot](https://github.com/dependabot) can keep our version of Poetry up-to-date. If you're unfamiliar with Dependabot, it's a... bot that monitors your project's dependencies, checks for updated versions on the corresponding package indexes, and updates the dependency in a branches / pull request. You can either manually review the PR or if you have a good CI setup with good tests, your CI will tell you whether the update can be safely merged in. It can monitor [many different languages and package managers](https://docs.github.com/en/code-security/dependabot/dependabot-version-updates/about-dependabot-version-updates) including pip, Poetry's flavor of `pyproject.toml` (another point for Poetry), `Pipfile`, and even `Dockerfile` dependencies. We use it in our projects to monitor everything we possibly can. While it can monitor Python and Docker dependencies, it can't monitor Python dependencies specified inline in a `Dockerfile`, even if you specify a pinned version. For that reason,  If you're not using Dependabot, run don't walk yada yada... It's now integrated into GitHub and free. We'll likely further sing its praises in future posts.

Moving on. If we take a look at our `pyproject.toml`, we can instantly see some of the quality-of-life benefits:

```toml 002-poetic-python-package-management/poetryapp/requirements/pyproject.toml
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

Easy to read. Easy to modify. Difficult to mess up. We now have more information about our project than `requirements.txt` allows. We have a clear separation between our universal dependencies and our dev dependencies in one file. We can install them selectively using Poetry's [--with, --without, and --only](https://python-poetry.org/docs/cli/#install) command line options (new as of version 1.2.0):

```dockerfile 002-poetic-python-package-management/poetryapp/Dockerfile [54]
    poetry install --no-cache --no-interaction --without dev && \
```

```dockerfile 002-poetic-python-package-management/poetryapp/Dockerfile [94]
    poetry install --no-cache --no-interaction --only dev && \
```

What did we really improve? We're jumping through some extra hoops. We have the same number of files. Was it worth it?

Once you have this pattern working, you shouldn't really have to mess with the hoops. You won't need to touch the `requirements.txt` file often, especially if you take our above advice regarding Dependabot. New dependencies or other metadata changes can be done directly to your `pyproject.toml` file. Should Poetry, or one of the other new package managers, becomes official, these hoops will essentially disappear. They could also be absorbed into a Docker image with Poetry pre-installed (future post?).

Whether the improvements outweigh the added complexity is debatable. We're happy with this version of the dev dependency installation pattern but you decide for yourself. If you have a cleaner approach to solving this problem, we'd love to hear from you. Hopefully, this post makes it easier for you to consider trying Poetry.

Until next time, don't be afraid to experiment.

**All code referenced in this post can be found [here](https://github.com/Analogous-Structures-Labs/astruct-blog-examples/tree/main/002-poetic-python-package-management).**
