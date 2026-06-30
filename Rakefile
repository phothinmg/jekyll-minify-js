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

desc "Release to rubygem.org"
task :release do
  puts "Start Building ..."
  # Run Build
  Rake::Task[:plugin_build].invoke
  Rake::Task[:publish].invoke
  puts "Finished"
end
