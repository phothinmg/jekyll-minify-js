<!-- markdownlint-disable MD033 -->
<!-- markdownlint-disable MD041 -->
<p align="center">
<img src="https://pub-c9ba018358dd48a99b70013b65a25e5f.r2.dev/logo/rubygems_logo.webp" width="160" height="160" alt="ruby"/>
</p>
<h1 align="center">Jekyll Minify Js</h1>

Jekyll plugin that minifies JavaScript files with Terser after the site is written.

## Features

- Minifies all `.js` files from a configurable source directory.
- Writes minified output into a configurable destination directory.
- Generates source maps by default.
- Falls back to copying the original file if minification fails.

## Requirements

- Ruby 3.1+
- Jekyll 4.4+

## Installation

Add the gem to your Jekyll site's `Gemfile`:

```ruby
gem 'jekyll-minify-js'
```

Then install dependencies:

```sh
bundle install
```

## Configuration

Add a `minify_js` section to `_config.yml`:

```yml
minify_js:
  enable: true
  entry_dir: js
  output_dir: js
  compress: true
  mangle: true
  source_map: true
```

### Options

| Option       | Type    | Default | Description                                                          |
| ------------ | ------- | ------- | -------------------------------------------------------------------- |
| `enable`     | boolean | `true`  | Set to `false` to skip minification.                                 |
| `entry_dir`  | string  | `js`    | Directory inside your source site containing input JavaScript files. |
| `output_dir` | string  | `js`    | Directory inside `_site` where minified files are written.           |
| `compress`   | boolean | `true`  | Enables Terser compression.                                          |
| `mangle`     | boolean | `true`  | Enables Terser name mangling.                                        |
| `source_map` | boolean | `true`  | Generates `.map` files and appends `sourceMappingURL`.               |

## How It Works

During Jekyll's `post_write` hook, the plugin:

1. Reads JavaScript files from `entry_dir`.
2. Minifies each file with Terser.
3. Writes the result to `_site/output_dir`.
4. Writes a source map when `source_map` is enabled.
5. Copies the original file if Terser raises an error for that file.

Directory structure example:

```text
your-site/
  js/
    app.js
    vendor/
      search.js
  _site/
    js/
      app.js
      app.js.map
      vendor/
        search.js
        search.js.map
```

## Example

If your source files live in `assets/js` and you want output in `assets/js` inside `_site`:

```yml
minify_js:
  entry_dir: assets/js
  output_dir: assets/js
  compress: true
  mangle: true
  source_map: true
```

## Development

Install dependencies:

```sh
bundle install
```

Run checks:

```sh
bundle exec rubocop
```

## License

Released under the MIT License. See `LICENSE.txt`.
