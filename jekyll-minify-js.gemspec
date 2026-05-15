# frozen_string_literal: true

require_relative 'lib/version'

Gem::Specification.new do |s|
  s.required_ruby_version = '>= 3.1'
  s.name = 'jekyll-minify-js'
  s.version = Jekyll::MinifyJs::VERSION
  s.authors = ['Pho Thin Maung']
  s.summary = 'Jekyll plugin for Minify Js.'
  s.email = 'phothinmg@disroot.org'
  s.files = [*Dir['lib/**/*.rb'], 'LICENSE.txt']
  s.homepage = 'https://github.com/phothinmg/jekyll-minify-js'
  s.license = 'MIT'
  s.metadata['rubygems_mfa_required'] = 'true'
  s.add_dependency 'fileutils', '~> 1.8'
  s.add_dependency 'jekyll', '~> 4.4'
  s.add_dependency 'terser', '~> 1.2'
end
