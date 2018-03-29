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
            args: [:locales,
                   ['-p', '--path PATH', 'Destination path', default: './source']]

        def preprocessing(opt = {})
          locale = opt[:locales].first
          folders = Dir["#{opt[:path]}/**/"]
          origin_files = Dir["#{opt[:path]}/*"]
          dic = {}
          origin_files.each do |file|
            # dic.merge!(origin_file_read(file)) { |key, v1, v2| fail "conflict: #{key}: #{v1}, #{v2} in #{file}" unless v1 == v2 }
            dic.merge!(origin_file_read(file))
          end
          path_origin = './config/locales/origin/'
          path_dictionary = './config/locales/dictionary/'
          path = locale == 'zh-CN' ? path_origin : path_dictionary
          keys_source(dic, path, locale)
          $stderr.puts Rainbow('origin file transform to yaml file successfully').green unless locale == 'en'
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

        # def generate_forest(dic)
        #   forest = I18n::Processes::Data::Tree::Siblings.new
        #   forest.merge!I18n::Processes::Data::Tree::Siblings.from_flat_pairs(dic)
        # end

        def yaml_file(forest, path, local)
          filename = "#{path + local}.yml"
          local_file = File.new(filename, 'w')
          local_file.write("---\n#{local}:\n")
          forest.list.each do |tree|
            yaml_tree = tree.to_yaml.delete('---').sub!(/\n/, '')
            yaml_tree.each_line do |line|
              next if line == '/n'
              local_file.write(line.insert(0, '  '))
            end
          end
          local_file.close
        end

        def keys_source(dic, path, locale)
          filename = "#{path + locale}.yml"
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
