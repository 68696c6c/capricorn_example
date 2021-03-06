FROM golang:1.15-alpine as env

ENV CGO_ENABLED=0
ENV GOPROXY=https://proxy.golang.org,direct

RUN apk add --no-cache git gcc openssh mysql-client

# Install stringer for generating enum String methods.
RUN go get golang.org/x/tools/cmd/stringer

# Install swagger for generating API docs.
RUN go get -v github.com/go-swagger/go-swagger/cmd/swagger

# Install golangci-lint for linting.
RUN wget https://github.com/golangci/golangci-lint/releases/download/v1.24.0/golangci-lint-1.24.0-linux-amd64.tar.gz \
    && tar xzf golangci-lint-1.24.0-linux-amd64.tar.gz \
    && mv golangci-lint-1.24.0-linux-amd64/golangci-lint /usr/local/bin/golangci-lint

# Install goose for running migrations.
RUN go get -u github.com/pressly/goose/cmd/goose

RUN mkdir -p /capricorn-example
WORKDIR /capricorn-example


## Local development stage.
FROM env as dev
RUN go get github.com/go-delve/delve/cmd/dlv
RUN go get golang.org/x/tools/cmd/goimports
RUN apk add --no-cache bash
RUN echo 'alias ll="ls -lah"' >> ~/.bashrc


## Pipeline stage for running unit tests, linters, etc.
FROM env as built
COPY src /capricorn-example
RUN go build -i -o app
