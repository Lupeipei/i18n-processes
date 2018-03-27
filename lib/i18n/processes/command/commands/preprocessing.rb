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
                   ['-p', '--path PATH', 'Destination path', default: './upload']]

        def preprocessing(opt = {})
          backend_files = Dir["#{opt[:path]}/backend/*"]
          frontend_files = Dir["#{opt[:path]}/frontend/*"]
          dic = {}
          backend_files.each do |file|
            dic.merge! backend_read(file)
          end
          frontend_files.each do |file|
            dic.merge! frontend_read(file)
          end
        end

        def backend_read(file)
          a = {}
          File.open(file).read.each_line do |line|
            next if line =~ /^#/ || line == "\n"
            key = line.split('=').first.delete(' ')
            value = line.split('=').last
            a[key] = value
          end
        end

        def frontend_read(file)
          a = {}
          File.open(file).read.each_line do |line|
            next unless line.include?(':')
            key = line.split(': ').first.delete(' ')
            value = line.split(': ').last.delete(',')
            a[key] = value
          end
        end

      end
    end
  end
end
