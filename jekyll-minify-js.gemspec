# frozen_string_literal: true

Gem::Specification.new do |s|
  s.required_ruby_version = '>= 3.1'
  s.name = 'jekyll-minify-js'
  s.version = '0.1.0'
  s.authors = ['Pho Thin Maung']
  s.summary = 'Jekyll plugin for Minify Js.'
  s.email = 'phothinmg@disroot.org'
  s.files = [*Dir['lib/**/*.rb'], 'LICENSE']
  s.homepage = 'https://rubygems.org/gems/jekyll-minify-js'
  s.license = 'ISC'
  s.metadata['rubygems_mfa_required'] = 'true'
  s.add_dependency 'fileutils', '~> 1.8'
  s.add_dependency 'jekyll', '~> 4.4'
  s.add_dependency 'pathname', '~> 0.4.0'
  s.add_dependency 'shellwords', '~> 0.2.2'
  s.add_dependency 'terser', '~> 1.2'
end
