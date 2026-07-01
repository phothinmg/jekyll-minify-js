# frozen_string_literal: true

require "jekyll"
require "json"
require "open3"
require "pathname"

require_relative "version"

module Jekyll
  # Minifies JavaScript assets after Jekyll finishes writing the site.
  #
  # The plugin reads files from a configured entry directory, invokes the
  # bundled Node-based terser wrapper, and writes the compiled assets into the
  # destination site output.
  module MinifyJs
    # Runs JavaScript minification from Jekyll's post-write lifecycle.
    #
    # The generator itself does not perform work during the normal generation
    # phase. Instead, {run} is invoked from a `:post_write` hook so Jekyll does
    # not overwrite the generated minified files.
    class TerserGenerator < Jekyll::Generator
      safe true
      priority :low

      # Declares the generator without doing work during the normal build phase.
      #
      # @param _site [Jekyll::Site] the site being generated
      # @return [void]
      def generate(_site)
        # Work is done in the :post_write hook to avoid Jekyll overwriting outputs.
      end

      # Merges the plugin configuration with defaults.
      #
      # @param site [Jekyll::Site] the current site instance
      # @return [Hash] the merged `minify_js` configuration
      def self.minify_js_config(site)
        default_config = {
          "enabled" => true,
          "entry_dir" => "js",
          "output_dir" => "js",
          "terser_opts" => {
            "source_map" => true,
            "compress" => true
          }
        }
        site.config["minify_js"] = default_config.merge(site.config["minify_js"] || {})
      end

      # Runs the Node-based terser wrapper for one JavaScript source string.
      #
      # @param code [String] the JavaScript source to minify
      # @param ts_opts [Hash, nil] terser options passed to the wrapper
      # @return [Hash] the parsed JSON response from the wrapper
      # @raise [RuntimeError] if the wrapper process exits unsuccessfully
      def self.run_terser(code, ts_opts)
        script_path = File.expand_path("../assets/index.js", __dir__)
        input = JSON.generate({
          code: code,
          opts: ts_opts
        }.compact)
        stdout, stderr, status = Open3.capture3("node", script_path, stdin_data: input)
        raise "Minify JS failed: #{stderr}" unless status.success?

        JSON.parse(stdout)
      end

      # Finds JavaScript files in the configured entry directory.
      #
      # @param site [Jekyll::Site] the current site instance
      # @param entry [String, nil] the source directory relative to `site.source`
      # @return [Array<String>, nil] matching absolute file paths, or `nil` when
      #   no entry directory is configured or no files are found
      def self.entry_js_files(site, entry)
        entry_full = File.join(site.source, entry)
        js_files = Dir.glob(File.join(entry_full, "**", "*.js"))
        if Dir.exist?(entry_full) && js_files.empty?
          Jekyll.logger.warn "MinifyJs:",
                             "No JavaScript files found in #{entry_full}."
        end
        return if entry.nil? || js_files.empty?

        js_files
      end

      # Resolves the output directory for minified assets.
      #
      # @param site [Jekyll::Site] the current site instance
      # @param out [String, nil] the configured output directory
      # @param entry [String] the configured entry directory
      # @return [String] the absolute destination directory inside `site.dest`
      def self.output_dir(site, out, entry)
        out ? File.join(site.dest, out) : File.join(site.dest, entry)
      end

      # Minifies every JavaScript file configured for the site.
      #
      # Files are written into the resolved output directory. If minification of
      # an individual file fails, the original file is copied instead.
      #
      # @param site [Jekyll::Site] the current site instance
      # @return [void]
      def self.run(site) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
        Jekyll.logger.info "Running jekyll-minify-js v#{Jekyll::MinifyJs::VERSION}"
        mini_js_config = minify_js_config(site)
        entry_dir = mini_js_config["entry_dir"]
        nil if (mini_js_config["enable"] && mini_js_config["enable"] == false) || entry_dir.nil?
        out_dir = output_dir(site, mini_js_config["output_dir"], entry_dir)
        ts_opts = mini_js_config["terser_opts"]
        entry_dir_full = File.join(site.source, entry_dir)
        js_files = entry_js_files(site, entry_dir)

        js_files.each do |src|
          rel = src.sub(/\A#{Regexp.escape(entry_dir_full + File::SEPARATOR)}/, "")
          out = File.join(out_dir, rel)
          map_name = "#{File.basename(out)}.map"
          src_content = File.read(src)
          result = run_terser(src_content, ts_opts)
          compiled = result["compiled"]
          source_map = result["source_map"]
          compiled += "\n//# sourceMappingURL=#{map_name}\n" if source_map && !compiled.include?("sourceMappingURL")
          File.write(out, compiled)
          File.write("#{out}.map", source_map) if source_map
        rescue StandardError => e
          Jekyll.logger.warn "jekyll-minify-js:", "failed to minify for #{rel}: #{e.message}; copying original"
          FileUtils.cp(src, out)
        end
      end
    end
  end
end

Jekyll::Hooks.register :site, :post_write do |site|
  Jekyll::MinifyJs::TerserGenerator.run(site)
end
