SHELL := bash

.PHONY: format lint build

format:
	bundle exec rufo .

lint:
	bundle exec rubocop

build:
	gem build jekyll-minify-js.gemspec
