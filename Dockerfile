# https://github.com/nsano-rururu/docker-compose-ui
# DOCKER-VERSION 1.13.2
FROM python:3.9.2-alpine AS builder
MAINTAINER Francesco Uliana <francesco@uliana.it>

RUN pip install virtualenv

RUN apk add -U --no-cache cargo \
    git \
    gcc \
    libffi-dev \
    make \
    musl-dev \
    openssl \
    openssl-dev

COPY ./requirements.txt /app/requirements.txt
RUN virtualenv /env && \
    /env/bin/python -m pip install --upgrade pip && \
    /env/bin/pip install --no-cache-dir cryptography && \
    /env/bin/pip install --no-cache-dir -r /app/requirements.txt

COPY . /app
COPY demo-projects /opt/docker-compose-projects

FROM python:3.9.1-alpine

RUN apk add -U --no-cache git 

VOLUME ["/opt/docker-compose-projects"]

COPY --from=builder /env /env
COPY --from=builder /app /app
COPY --from=builder /opt/docker-compose-projects /opt/docker-compose-projects

EXPOSE 5000

CMD []
ENTRYPOINT ["/env/bin/python", "/app/main.py"]

WORKDIR /opt/docker-compose-projects/
