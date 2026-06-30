# frozen_string_literal: true

require "yard"

require "bundler/gem_tasks"
require "rubocop/rake_task"

RuboCop::RakeTask.new

task default: :rubocop

# 1. Initial Setup
# ================
task :setup do
  sh "bin/setup"
end

# 2. Bundle
# =========

task :install do
  sh "bundle install"
end

# 3. Plugin
# =========
task :plugin_build do
  sh "gem build jekyll-minify-js.gemspec"
end

task :publish do
  sh "bash bin/publish"
end

# 4. YardDoc
# ==========

YARD::Rake::YardocTask.new do |t|
  # Leave t.files empty so it doesn't merge incorrectly
  t.files = []

  t.options = [
    "--no-yardopts",
    "--title", "Jekyll Minify Js",
    "-p", "yard/templates",
    "--asset", "yard/assets/favicon.svg:favicon.svg",
    "lib/**/*.rb",
    "-o", "docs",
    "-",
    "README.md",
    "CHANGELOG.md",
    "LICENSE.txt"
  ]
end
