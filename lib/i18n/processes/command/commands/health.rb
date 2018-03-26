# frozen_string_literal: true

require 'i18n/processes/command/collection'
module I18n::Processes
  module Command
    module Commands
      module Health
        include Command::Collection

        cmd :health,
            pos:  '[locale ...]',
            desc: t('i18n_processes.cmd.desc.health'),
            args: %i[locales out_format]

        def health(opt = {})
          forest = i18n.data_forest(opt[:locales])
          stats  = i18n.forest_stats(forest)
          fail CommandError, t('i18n_processes.health.no_keys_detected') if stats[:key_count].zero?
          terminal_report.forest_stats forest, stats
          $stderr.puts Rainbow("#{opt}").green
          [missing(opt), unused(opt), check_normalized(opt)].detect { |result| result == :exit_1 }
        end
      end
    end
  end
end
