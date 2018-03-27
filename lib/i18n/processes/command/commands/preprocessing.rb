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
                   ['-p', '--path PATH', 'Destination path', default: './upload/*']]

        def preprocessing(opt = {})
          files = Dir[opt[:path]]
          files.each do |file|
            file_name = File.basename(file,".*")
            yaml_file = File.new(".config/locales/origin/#{file_name}.zh.yml", 'w')
            yaml_file.write("---\nzh:\n")
            File.open(file).read.each_line do |line|
              ## backend zh preprocessing
              if line !~ /^#/
                new_line = "  #{line.gsub(' ','').gsub(/=/, ': ')}"
                yaml_file.write new_line
              end
            end
            yaml_file.close
          end
        end

      end
    end
  end
end
