# Hello Makefile

GREEN  := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
WHITE  := $(shell tput -Txterm setaf 7)
CYAN   := $(shell tput -Txterm setaf 6)
RESET  := $(shell tput -Txterm sgr0)

GO?=~/go
GOCMD?=go

# Version Handling - See: https://blog.kowalczyk.info/article/vEja/embedding-build-number-in-go-executable.html
TAGS=$(git rev-list --tags --max-count=1)
VERSION:=$(shell git describe --tags --dirty)
HASH:=$(shell git rev-parse HEAD)

GO_LDFLAGS:=-ldflags "-X github.com/dsackinger/hello/pkg/version.Version=$(VERSION) -X github.com/dsackinger/hello/pkg/version.Hash=$(HASH)"

GO_FILES_HELLO := $(shell find cmd/hello -name '*.go')

.PHONY: install ## Build the hello app
install: $(GO_FILES_HELLO)
	GO111MODULE=on $(GOCMD) install $(GO_FLAGS) ./cmd/hello

IMAGE_NAME=hello

.PHONY: build
build: ## Builds the docker container
	docker build . -f docker/Dockerfile --tag $(IMAGE_NAME)

help: ## Show this help.
	@echo ''
	@echo 'Usage:'
	@echo '  ${YELLOW}make${RESET} ${GREEN}<target>${RESET}'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} { \
		if (/^[a-zA-Z_-]+:.*?##.*$$/) {printf "    ${YELLOW}%-20s${GREEN}%s${RESET}\n", $$1, $$2} \
		else if (/^## .*$$/) {printf "  ${CYAN}%s${RESET}\n", substr($$1,4)} \
		}' $(MAKEFILE_LIST)
