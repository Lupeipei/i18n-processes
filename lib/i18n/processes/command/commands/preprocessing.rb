# frozen_string_literal: true

require 'i18n/processes/command/collection'
require 'i18n/processes/path'
require 'fileutils'

module I18n::Processes
  module Command
    module Commands
      module Preprocessing
        include Command::Collection
        include Path

        cmd :preprocessing,
            pos:  '[locale...]',
            desc: 'preprocess origin data files into primitive files with key=value format',
            args: %i[locales out_format]

        def preprocessing(opt = {})
          locale = opt[:locales].include?(base_locale) ? 'zh-CN' : opt[:locales].first
          dic = {}
          origin_files(locale).flatten.each do |file|
            # dic.merge!(origin_file_read(file)) { |key, v1, v2| fail "conflict: #{key}: #{v1}, #{v2} in #{file}" unless v1 == v2 }
            dic.merge!(origin_file_read(file))
          end
          path = compare_path.first
          keys_source(dic, path, locale)
          $stderr.puts Rainbow('fetch all keys and values from origin files').green if locale == base_locale
        end

        def origin_file_read(file)
          {}.tap do |a|
            File.open(file).read.each_line do |line|
              next if line =~ /^#/ || line == "\n" || !line.include?('.')
              if line.include?('\':')
                line.gsub!(/'|,/, '')
                key = line.split(': ').first.delete(' ')
                value = line.split(': ').last
              else
                key = line.split('=').first.delete(' ')
                value = line.split('=').last
              end
              a[key] = value
            end
          end
        end

        def keys_source(dic, path, locale)
          filename = path + locale
          File.delete(filename) if File.exist?(filename)
          local_file = File.new(filename, 'w')
          dic.map do |key, value|
            value.include?("\n") ? local_file.write("#{key}=#{value}") : local_file.write("#{key}=#{value}\n")
          end
          local_file.close
        end
      end
    end
  end
end
