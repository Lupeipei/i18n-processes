# frozen_string_literal: true

require 'i18n/processes/command/collection'
module I18n::Processes
  module Command
    module Commands
      module XLSX
        include Command::Collection

        cmd :xlsx_report,
            pos:  '[locale...]',
            desc: t('i18n_processes.cmd.desc.xlsx_report'),
            args: [:locales,
                   ['-p', '--path PATH', 'Destination path', default: 'tmp/i18n-report.xlsx']]

        def xlsx_report(opt = {})
          begin
            require 'axlsx'
          rescue LoadError
            message = %(For spreadsheet report please add axlsx gem to Gemfile:\ngem 'axlsx', '~> 2.0')
            log_stderr Rainbow(message).red.bright
            exit 1
          end
          $stderr.puts Rainbow("#{opt}").green
          spreadsheet_report.save_report opt[:path], opt.except(:path)
        end
      end
    end
  end
end
