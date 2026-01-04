jekyll-minify-js
=================

A small Jekyll plugin that minifies JavaScript files found under common asset
directories during site builds. The plugin prefers the `terser` Ruby gem when
available and falls back to an external `terser` CLI if necessary. When no
minifier is available, original JS files are copied through unchanged.

**Features**

- Minifies `.js` files under `assets/js` or `app/assets/js` (whichever exists).
- Uses the `terser` Ruby gem when installed, otherwise tries an external
	`terser` CLI (e.g., npm-installed `terser`).
- Emits source maps when enabled in configuration.
- Skips files matching configured exclude patterns (default: `**/*.min.js`).

Installation
------------

1. Add the gem to your site's `Gemfile` and run `bundle install`:

	 gem 'jekyll-minify-js'

2. Enable the plugin in your `_config.yml` (Jekyll 3.5+):

	 plugins:
		 - jekyll-minify-js

Or, for older Jekyll versions, add the gem name to the `gems:` list instead.

Usage
-----

On `jekyll build` the plugin will look for a source JS directory and produce
minified output into your site's destination directory. It searches for the
first directory that exists in this list:

- `assets/js`
- `app/assets/js`

Configuration
-------------

Add a `minify_js:` section to `_config.yml` to control behavior. All options
are optional and shown here with their defaults:

minify_js:
	enabled: true          # set to false to disable the plugin
	output_dir: assets/js  # destination directory under the site `dest`
	compress: true         # enable terser compress option
	mangle: true           # enable terser mangle option
	source_map: true       # emit source maps alongside minified files
	exclude:               # glob patterns to skip (relative to source js dir)
		- "**/*.min.js"

Examples
--------

Given a source file `assets/js/app.js`, after a build you will find the
minified file at `_site/assets/js/app.js` and, if enabled, the source map at
`_site/assets/js/app.js.map`.

Requirements
------------

- The plugin itself has no hard dependency on the `terser` gem — it will work
	without it by attempting to call an external `terser` binary. For best
	results install either:

	- the `terser` Ruby gem (preferred), or
	- the `terser` CLI (npm package `terser`) available on your PATH.

Development
-----------

Contributions and bug reports are welcome. The repository includes the source
under `lib/jekyll_minify_js.rb`. Please open issues or PRs for feature
requests, bug fixes, or documentation improvements.

License
-------

This project is licensed under the terms in the `LICENSE` file in the
repository root.
