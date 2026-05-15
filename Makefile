SHELL := bash

.PHONY: format lint build publish

format:
	bundle exec rufo .

lint:
	bundle exec rubocop

build:
	gem build jekyll-minify-js.gemspec

publish:
	bash bin/publish

