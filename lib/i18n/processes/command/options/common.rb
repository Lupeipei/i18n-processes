# frozen_string_literal: true

require 'i18n/processes/command/dsl'

module I18n::Processes
  module Command
    module Options
      module Common
        include Command::DSL

        arg :nostdin,
            '-S',
            '--nostdin',
            'Do not read from stdin'

        arg :confirm,
            '-y',
            '--confirm',
            desc: 'Confirm automatically'

        arg :pattern,
            '-p',
            '--pattern PATTERN',
            "Filter by key pattern (e.g. 'common.*')"

        arg :value,
            '-v',
            '--value VALUE',
            'Value. Interpolates: %{value}, %{human_key}, %{key}, %{default}, %{value_or_human_key}, %{value_or_default_or_human_key}'

        def arg_or_pos!(key, opts)
          opts[key] ||= opts[:arguments].try(:shift)
        end

        def pos_or_stdin!(opts)
          opts[:arguments].try(:shift) || $stdin.read
        end
      end
    end
  end
end
