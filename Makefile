SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

.PHONY: help init outdated update generate lint test

help: ## List all available targets with help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

init: ## Prepare project for development
	git config core.hooksPath .githooks
	go mod download
	go generate ./...

generate: ## Run code generation
	go generate ./...

outdated: ## List outated dependencies
	go list -u -m -f '{{if .Update}}{{.}}{{end}}'

update: ## Update go.mod dependencies
	go get -u ./...
	go mod tidy

lint: ## Run golangci-lint
	golangci-lint run

test: ## Run only unit tests
	go test -v ./...
