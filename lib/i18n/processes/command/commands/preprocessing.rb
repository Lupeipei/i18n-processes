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
          filename = keys_source(dic, path, locale)
          if locale == base_locale
            $stderr.puts Rainbow('preprocess origin data files into primitive files successfully').green
            previous_file = "#{path}previous/pre_#{base_locale}"
            changed_keys(previous_file,filename ) if File.exist?(previous_file)
          end
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
          # previous_file = "#{path}pre_#{locale}"
          # FileUtils::mkdir_p File.dirname(filename) unless Dir.exist?File.dirname(filename)
          # File.delete(previous_file) if File.exist?(previous_file)
          # File.rename(filename, previous_file) if File.exist?(filename)
          local_file = File.new(filename, 'w')
          dic.map do |key, value|
            value.include?("\n") ? local_file.write("#{key}=#{value}") : local_file.write("#{key}=#{value}\n")
          end
          local_file.close
          filename
        end

        def changed_keys(previous, current)
          previous_dic = get_dic(previous)
          current_dic = get_dic(current)
          diff = current_dic.merge(previous_dic){|k, v1, v2| {:current => v1, :previous => v2} unless v1 == v2 }
          diff.select!{ |k, v| v.is_a?(Hash)}
          unless diff == {}
            print_changed_keys(diff)
            changed_keys_save(diff)
            fail "need to update #{diff.count} keys' translation"
          end
        end

        def changed_keys_save(diff)
          file = "#{compare_path.first}changed_keys/changed_keys"
          FileUtils::mkdir_p File.dirname(file) unless Dir.exist?File.dirname(file)
          changed_keys = File.new(file, 'w')
          diff.each do |k, v|
            changed_keys.write "key: #{k}\n"
            changed_keys.write "current: #{v[:current]}"
            changed_keys.write "previous: #{v[:previous]}"
            changed_keys.write "\n"
          end
          changed_keys.close
          log_warn("changed_keys save to #{file}")
        end
      end
    end
  end
end
