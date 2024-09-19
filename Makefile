.DEFAULT_GOAL := usage

# user and repo
USER        = $$(whoami)
CURRENT_DIR = $(notdir $(shell pwd))

# terminal colours
RED     = \033[0;31m
GREEN   = \033[0;32m
YELLOW  = \033[0;33m
NC      = \033[0m
# versions
APP_REVISION    = $(shell git rev-parse HEAD)

.PHONY: install
install:
	bundle install

.PHONY: run
run:
	bundle exec ruby lib/app.rb 

.PHONY: run-dev
run-dev:
	bundle exec rerun 'ruby lib/app.rb'

.PHONY: open
open:
	open http://localhost:4567/

.PHONY: lint
lint:
	bundle exec rubocop -a

.PHONY: lint-force
lint-force:
	bundle exec rubocop -A

.PHONY: test
test:
	bundle exec rspec

.PHONY: usage
usage:
	@echo
	@echo "Hi ${GREEN}${USER}!${NC} Welcome to ${RED}${CURRENT_DIR}${NC}"
	@echo
	@echo "Getting started"
	@echo
	@echo "${YELLOW}make install${NC}                  install dependencies"
	@echo "${YELLOW}make test${NC}                     test app"
	@echo
	@echo "${YELLOW}make run${NC}                      run server"
	@echo "${YELLOW}make open${NC}                     open app"
	@echo
	@echo "${YELLOW}make lint${NC}                     lint app"
	@echo "${YELLOW}make lint-force${NC}               lint app (UNSAFE)"
	@echo "${YELLOW}make run-dev${NC}                  run server with source reload(devmode)"
	@echo

