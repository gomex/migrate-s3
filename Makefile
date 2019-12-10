# import env config

cnf ?= .env
include $(cnf)
export $(shell sed 's/=.*//' $(cnf))

GIT_COMMIT=$(shell git log -1 --format=%h)

# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

build: ## build the image to run the migration
	docker build -t migration:$(GIT_COMMIT) .

migrate: build ## run the migration
	docker run --env-file ./.env migration:$(GIT_COMMIT)