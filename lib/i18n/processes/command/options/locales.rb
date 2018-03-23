# frozen_string_literal: true

require 'i18n/processes/command/option_parsers/locale'
require 'i18n/processes/command/dsl'
module I18n::Processes
  module Command
    module Options
      module Locales
        include Command::DSL

        arg :locales,
            '-l',
            '--locales en,es,ru',
            Array,
            t('i18n_processes.cmd.args.desc.locales_filter'),
            parser:             OptionParsers::Locale::ListParser,
            default:            'all',
            consume_positional: true

        arg :locale,
            '-l',
            '--locale en',
            t('i18n_processes.cmd.args.desc.locale'),
            parser:  OptionParsers::Locale::Parser,
            default: 'base'

        arg :locale_to_translate_from,
            '-f',
            '--from en',
            t('i18n_processes.cmd.args.desc.locale_to_translate_from'),
            parser:  OptionParsers::Locale::Parser,
            default: 'base'
      end
    end
  end
end
