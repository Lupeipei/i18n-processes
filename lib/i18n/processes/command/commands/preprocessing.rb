# frozen_string_literal: true

require 'i18n/processes/command/collection'

module I18n::Processes
  module Command
    module Commands
      module Preprocessing
        include Command::Collection

        cmd :preprocessing,
            pos:  '[locale...]',
            desc: 'preprocess origin data files into yaml format files',
            args: {}

        def preprocessing(opt = {})
          locale = opt[:locales].nil? ? 'zh-CN' : opt[:locales].first
          dic = {}
          origin_files(locale).each do |file|
            # dic.merge!(origin_file_read(file)) { |key, v1, v2| fail "conflict: #{key}: #{v1}, #{v2} in #{file}" unless v1 == v2 }
            dic.merge!(origin_file_read(file))
          end
          path = 'tmp/'
          keys_source(dic, path, locale)
          $stderr.puts Rainbow('origin file transform to yaml file successfully').green if locale == 'zh-CN'
        end

        def origin_files(locale)
          source = locale == 'zh-CN' ? source_path.first : translation_path.first
          Dir.glob("#{source}**/*.*")
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
          # filename = "#{path + locale}.yml"
          filename = path + locale
          local_file = File.new(filename, 'w')
          dic.map do |key, value|
            value.include?("\n") ? local_file.write("#{key}=#{value}") : local_file.write("#{key}=#{value}\n")
          end
          local_file.close
        end

        def source_path
          config_file[:data][:source]
        end

        def translation_path
          config_file[:data][:translation]
        end

        def translated_path
          config_file[:data][:translated]
        end

        def config_file
          file = Dir.glob(File.join('**', '*.yml')).select{ |x| x.include?'i18n-processes'}
          YAML.load_file(file.first).deep_symbolize_keys unless file.empty?
        end

      end
    end
  end
end
