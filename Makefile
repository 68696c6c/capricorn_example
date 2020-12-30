DCR = docker-compose run --rm

NETWORK_NAME ?= docker-dev
APP_NAME = capricorn_example
DB_NAME = db_capricorn_example

DOC_PATH_BASE = docs/swagger.json
DOC_PATH_FINAL = docs/api-spec.json

.PHONY: docs build

.DEFAULT:
	@echo 'App targets:'
	@echo
	@echo '    image-local        build the $(APP_NAME):local Docker image for local development'
	@echo '    image-built        build the $(APP_NAME):built Docker image for task running'
	@echo '    build              compile the app for use in Docker'
	@echo '    init               initialize the Go module'
	@echo '    deps               install dependencies'
	@echo '    setup-network      create local Docker network'
	@echo '    setup              set up local databases'
	@echo '    local              spin up local dev environment'
	@echo '    local-down         tear down local dev environment'
	@echo '    migrate            migrate the local database'
	@echo '    migration          create a new migration'
	@echo '    generate           generate String methods for app enum types'
	@echo '    docs               build the Swagger docs'
	@echo '    docs-server        build and serve the Swagger docs'
	@echo '    test               run unit tests'
	@echo '    lint               run the linter'
	@echo '    lint-fix           run the linter and fix any problems'
	@echo


default: .DEFAULT

image-local:
	docker build . --target dev -t $(APP_NAME):local

image-built:
	docker build . --target built -t $(APP_NAME):built

build:
	$(DCR) $(APP_NAME) go build -i -o capricorn_example

deps:
	$(DCR) $(APP_NAME) go mod tidy
	$(DCR) $(APP_NAME) go mod vendor

setup-network:
	docker network create docker-dev || exit 0

setup: setup-network image-local generate deps build
	@test -f ".app.env" || (echo "you need to set up your .app.env file before running this command"; exit 1)
	$(DCR) $(DB_NAME) mysql -u root -psecret -h $(DB_NAME) -e "CREATE DATABASE IF NOT EXISTS capricorn_example"
	$(DCR) $(APP_NAME) bash -c "./capricorn_example migrate up"

local: local-down build
	docker-compose up $(APP_NAME)

local-down:
	docker-compose rm -sf

test:
	$(DCR) $(APP_NAME) go test ./... -cover

migrate: build
	$(DCR) $(APP_NAME) ./capricorn_example migrate up

migration: build
	$(DCR) $(APP_NAME) goose -dir github.com/68696c6c/capricorn-example/db/migrations create $(name)

generate:
	$(DCR) $(APP_NAME) go generate github.com/68696c6c/capricorn-example/app/enums

docs: build
	$(DCR) $(APP_NAME) bash -c "GO111MODULE=off swagger generate spec -mo '$(DOC_PATH_BASE)'"
	$(DCR) $(APP_NAME) ./capricorn_example gen:docs

docs-server: docs
	swagger serve "$(DOC_PATH_FINAL)"

lint:
	$(DCR) $(APP_NAME) golangci-lint run

lint-fix:
	$(DCR) $(APP_NAME) golangci-lint run --fix
