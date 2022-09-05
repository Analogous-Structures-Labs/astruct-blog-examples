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
