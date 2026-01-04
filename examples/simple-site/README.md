Simple example site for jekyll-minify-js
======================================

This tiny example demonstrates how to use the `jekyll-minify-js` plugin
locally against a simple Jekyll site.

Quick start
-----------

From the `examples/simple-site` directory run:

```bash
bundle install
# Optionally install the terser CLI if you want to use the external terser:
# npm install -g terser

# Build the site with the local plugin
bundle exec jekyll build
```

After the build the minified JavaScript (and source map if enabled) will be
written into `_site/assets/js/app.js` and `_site/assets/js/app.js.map`.

Notes
-----

- The example's `Gemfile` points to the plugin in the repository root via a
  `path:` gem declaration so you can work on the plugin and test it locally.
- If you prefer the Ruby `terser` gem, install it into the example site's
  bundle instead of installing the `terser` CLI.
