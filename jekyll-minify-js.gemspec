# frozen_string_literal: true

Gem::Specification.new do |ptm|
  ptm.required_ruby_version = '>= 3.4.8'
  ptm.name = 'jekyll-minify-js'
  ptm.version = Jekyll::MinifyJs::VERSION
  ptm.authors = ['Pho Thin Maung']
  ptm.summary = 'Jekyll plugin for Minify Js.'
  ptm.email = 'phothinmg@disroot.org'
  ptm.files = [*Dir['lib/**/*.rb'], 'LICENSE']
  ptm.homepage = 'https://rubygems.org/gems/hola'
  ptm.license = 'ISC'
  ptm.metadata['rubygems_mfa_required'] = 'true'

  ptm.add_dependency 'jekyll', '~> 4.4'
  ptm.add_dependency 'terser', '~> 1.2'
end
