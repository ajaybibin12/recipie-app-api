FROM python:3.12.2-slim
LABEL maintainers="ajaybibin12@gmail.com"

ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /temp/requirements.txt
COPY ./requirements.dev.txt /temp/requirements.dev.txt
COPY ./app /app
WORKDIR /app

EXPOSE 8000

ARG DEV=false
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    apt-get update && apt-get install -y --no-install-recommends \
        postgresql-client \
        build-essential \
        libpq-dev \
        gcc \
        musl-dev && \
    /py/bin/pip install -r /temp/requirements.txt && \
    if [ "$DEV" = "true" ] ; then /py/bin/pip install -r /temp/requirements.dev.txt ; fi && \
    rm -rf /temp && \
    apt-get purge -y --auto-remove \
        build-essential \
        gcc \
        musl-dev && \
    rm -rf /var/lib/apt/lists/* && \
    adduser --disabled-password --gecos '' myuser && \
    adduser myuser sudo && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
ENV PATH="/py/bin:$PATH"

USER myuser
