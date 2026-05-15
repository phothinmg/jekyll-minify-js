require 'logger'
# frozen_string_literal: true

require 'jekyll'
require 'fileutils'
require 'terser'

require_relative 'version'
require_relative 'color'

# module Jekyll
module Jekyll
  # module Jekyll::MinifyJs
  module MinifyJs
    # class Jekyll::MinifyJs:TerserGenerator
    class TerserGenerator < Jekyll::Generator
      safe true
      priority :low

      def generate(_site)
        # Work is done in the :post_write hook to avoid Jekyll overwriting outputs.
      end

      def self.run(site) # rubocop:disable Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/MethodLength,Metrics/PerceivedComplexity
        config = site.config['minify_js'] || {}
        # disable to skip minification
        return if config['enable'] && config['enable'] == false

        started_at = Process.clock_gettime(Process::CLOCK_MONOTONIC)
        # Build options from config
        compress_opt = config.fetch('compress', true)
        mangle_opt = config.fetch('mangle', true)
        source_map_enabled = config.fetch('source_map', true)

        Jekyll.logger.info ''
        Jekyll.logger.info set_color(96, "Running Jekyll MinifyJs v#{Jekyll::MinifyJs::VERSION}", 1)

        entry_dir = config['entry_dir'] || 'js'
        out_dir = config['output_dir'] || 'js'

        if config['entry_dir']
          Jekyll.logger.info "Entry  : #{File.join(site.source, config['entry_dir'])}"
        else
          Jekyll.logger.info "Entry  : No entry_dir found, look in #{File.join(site.source, 'js')}"
        end

        if config['output_dir']
          Jekyll.logger.info "Output : #{File.join(site.dest, config['output_dir'])}"
        else
          Jekyll.logger.info "Output : No output_dir found, write to #{File.join(site.dest, 'js')}"
        end

        entry_dir_full = File.join(site.source, entry_dir)
        out_dir_full = File.join(site.dest, out_dir)
        js_files = Dir.glob(File.join(entry_dir_full, '**', '*.js'))

        Jekyll.logger.warn 'MinifyJs:', "Entry directory not found: #{entry_dir_full}" unless Dir.exist?(entry_dir_full)
        if Dir.exist?(entry_dir_full) && js_files.empty?
          Jekyll.logger.info 'MinifyJs:',
                             "No JavaScript files found in #{entry_dir_full}"
        end

        FileUtils.mkdir_p(out_dir_full)

        js_files.each do |src|
          rel = src.sub(/\A#{Regexp.escape(entry_dir_full + File::SEPARATOR)}/, '')
          out = File.join(out_dir_full, rel)
          map_name = "#{File.basename(out)}.map"

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
            if source_map_enabled && !compiled.include?('sourceMappingURL')
              compiled += "\n//# sourceMappingURL=#{map_name}\n"
            end
            File.write(out, compiled)
            File.write("#{out}.map", map) if map
          rescue StandardError => e
            Jekyll.logger.warn 'Terser:', "ruby terser failed for #{rel}: #{e.message}; copying original"
            FileUtils.cp(src, out)
          end
        end

        elapsed = Process.clock_gettime(Process::CLOCK_MONOTONIC) - started_at
        Jekyll.logger.info set_color(92, format('Done in %.2fs', elapsed), 1)
      end
    end
  end
end

Jekyll::Hooks.register :site, :post_write do |site|
  Jekyll::MinifyJs::TerserGenerator.run(site)
end
