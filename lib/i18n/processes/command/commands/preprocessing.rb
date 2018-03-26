# frozen_string_literal: true

require 'i18n/processes/command/collection'
module I18n::Processes
  module Command
    module Commands
      module Preprocessing
        include Command::Collection

        cmd :preprocessing,
            pos:  '[locale...]',
            desc: t('i18n_processes.cmd.desc.preprocessing'),
            args: [:locales,
                   ['-p', '--path PATH', 'Destination path', default: 'config/locals/origin/']]

        def preprocessing(opt = {})
          $stderr.puts Rainbow("#{opt}").green
        end

      end
    end
  end
end
