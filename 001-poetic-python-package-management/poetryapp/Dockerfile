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
