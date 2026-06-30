# frozen_string_literal: true

require_relative "lib/version"

Gem::Specification.new do |spec|
  spec.name = "jekyll-minify-js"
  spec.version = Jekyll::MinifyJs::VERSION
  spec.authors = ["phothinmg"]
  spec.email = ["phothinmg@disroot.org"]
  spec.summary = "Jekyll plugin for Minify Js"
  spec.homepage = "https://github.com/phothinmg/jekyll-minify-js"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/phothinmg/jekyll-minify-js/blob/main/CHANGELOG.md"
  spec.metadata["rubygems_mfa_required"] = "true"
  spec.files = [*Dir["lib/**/*.rb"], *Dir["assets/**/*"], "LICENSE.txt", "README.md"]
  spec.require_paths = ["lib"]
  spec.add_dependency "jekyll", "~> 4.4"
  spec.add_dependency "open3", ">= 0.2.1"
end
