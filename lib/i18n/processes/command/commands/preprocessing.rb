# frozen_string_literal: true

require 'i18n/processes/command/collection'
require 'i18n/processes/data/tree/siblings'
require 'i18n/processes/data/router/pattern_router'
require 'i18n/processes/data/router/conservative_router'
require 'i18n/processes/data/file_formats'
require 'i18n/processes/key_pattern_matching'

module I18n::Processes
  module Command
    module Commands
      module Preprocessing
        include Command::Collection
        include I18n::Processes::Data::Tree
        include I18n::Processes::Data::FileFormats
        include I18n::Processes::Data::Router

        cmd :preprocessing,
            pos:  '[locale...]',
            desc: 'preprocess origin data files into yaml format files',
            args: [:locales,
                   ['-p', '--path PATH', 'Destination path', default: './upload']]

        def preprocessing(opt = {})
          locale = opt[:locales].first
          backend_files = Dir["#{opt[:path]}/backend/*"]
          frontend_files = Dir["#{opt[:path]}/frontend/*"]
          dic = {}
          backend_files.each do |file|
            dic.merge!(backend_read(file)) { |key, v1, v2| fail "conflict: #{key}: #{v1}, #{v2}" }
          end
          frontend_files.each do |file|
            dic.merge!(frontend_read(file)) { |key, v1, v2| fail "conflict: #{key}: #{v1}, #{v2}" }
          end
          forest = generate_forest(dic)
          path = './config/locales/origin/'
          yaml_file(forest, path, locale)
          $stderr.puts Rainbow('origin file transform to yaml file successfully').green
        end

        def backend_read(file)
          a = {}
          File.open(file).read.each_line do |line|
            next if line =~ /^#/ || line == "\n"
            key = line.split('=').first.delete(' ')
            value = line.split('=').last
            a[key] = value
          end
          return a
        end

        def frontend_read(file)
          a = {}
          File.open(file).read.each_line do |line|
            next unless line.include?(':')
            line.gsub!(/'|,/, '')
            key = line.split(': ').first.delete(' ')
            value = line.split(': ').last
            a[key] = value
          end
          return a
        end

        def generate_forest(dic)
          forest = I18n::Processes::Data::Tree::Siblings.new
          forest.merge!I18n::Processes::Data::Tree::Siblings.from_flat_pairs(dic)
        end

        def yaml_file(forest, path, local)
          filename = "#{path + local}.yml"
          local_file = File.new(filename, 'w')
          local_file.write("---\n#{local}:\n")
          forest.list.each do |tree|
            yaml_tree = tree.to_yaml.delete("---").sub!(/\n/,'')
            yaml_tree.each_line do |line|
              next if line =="/n"
              local_file.write(line.insert(0, '  '))
            end
          end
          local_file.close
        end

      end
    end
  end
end
