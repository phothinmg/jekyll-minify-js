SHELL := bash

.PHONY: format lint

format:
	bundle exec rufo .

lint:
	bundle exec rubocop
