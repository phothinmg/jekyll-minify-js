# frozen_string_literal: true

require 'jekyll'
require 'fileutils'
require 'shellwords'
begin
  require 'terser'
rescue LoadError
  # terser gem not available; plugin will fallback to external CLI or copy
end
require 'pathname'

# module Jekyll
module Jekyll
   module MinifyJs
     class TerserGenerator < Generator
    safe true
    priority :low

    def generate(_site)
      # Work is done in the :post_write hook to avoid Jekyll overwriting outputs.
    end

    def self.run(site) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength,Metrics/CyclomaticComplexity,Metrics/PerceivedComplexity
      # Support both repository-root layout and app/ layout.
      candidates = [
        File.join(site.source, 'assets', 'js'),
        File.join(site.source, 'app', 'assets', 'js')
      ]
      src_dir = candidates.find { |p| Dir.exist?(p) }
      return unless src_dir

      # Read configuration from _config.yml under `terser:` key
      cfg = site.config.fetch('terser', {})
      return if cfg.key?('enabled') && cfg['enabled'] == false

      dest_dir = File.join(site.dest, cfg.fetch('output_dir', 'assets/js'))
      FileUtils.mkdir_p(dest_dir)

      terser_available = defined?(Terser)

      # Build options from config
      compress_opt = cfg.fetch('compress', true)
      mangle_opt = cfg.fetch('mangle', true)
      source_map_enabled = cfg.fetch('source_map', true)
      exclude_patterns = cfg.fetch('exclude', ['**/*.min.js'])

      Dir.glob(File.join(src_dir, '**', '*.js')).each do |src| # rubocop:disable Metrics/BlockLength
        rel = Pathname.new(src).relative_path_from(Pathname.new(src_dir)).to_s
        out = File.join(dest_dir, rel)
        out_dir = File.dirname(out)
        FileUtils.mkdir_p(out_dir)
        map_name = "#{File.basename(out)}.map"

        # Skip excluded files
        next if exclude_patterns.any? { |pat| File.fnmatch(pat, rel) }

        if terser_available
          Jekyll.logger.info 'Terser:', "minifying #{rel} via terser Ruby gem"
          begin
            src_content = File.open(src, 'r:BOM|UTF-8', &:read)
            options = {}
            options[:compress] = compress_opt
            options[:mangle] = mangle_opt
            if source_map_enabled
              options[:source_map] =
                { filename: File.basename(src), output_filename: File.basename(out), sources_content: true,
                  url: map_name }
              compiled, map = Terser.compile_with_map(src_content, options)
            else
              compiled = Terser.compile(src_content, options)
              map = nil
            end
            compiled += "\n//# sourceMappingURL=#{map_name}\n" unless compiled.include?('sourceMappingURL')
            File.write(out, compiled)
            File.write("#{out}.map", map) if map
          rescue StandardError => e
            Jekyll.logger.warn 'Terser:', "ruby terser failed for #{rel}: #{e.message}; copying original"
            FileUtils.cp(src, out)
          end
        else
          terser_cmd = new.detect_terser_cmd
          if terser_cmd
            cmd = %(#{terser_cmd} #{Shellwords.escape(src)} --compress --mangle -o #{Shellwords.escape(out)} --source-map "url='#{map_name}',includeSources") # rubocop:disable Layout/LineLength
            Jekyll.logger.info 'Terser:', "minifying #{rel} via external terser"
            success = system(cmd)
            unless success && File.exist?(out)
              Jekyll.logger.warn 'Terser:', "minify failed for #{rel}; copying original"
              FileUtils.cp(src, out)
            end
          else
            Jekyll.logger.warn 'Terser:', 'no terser available — copying original JS'
            FileUtils.cp(src, out)
          end
        end
      end
    end

    def detect_terser_cmd
      # Prefer the bundler-installed terser (from the `terser` gem) via `bundle exec terser`.
      return 'bundle exec terser' if system('bundle exec terser --version > /dev/null 2>&1')
      return 'terser' if system('terser --version > /dev/null 2>&1')

      nil
    end
  end

  end
end
