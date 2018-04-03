# frozen_string_literal: true

require 'i18n/processes/command/collection'
require 'i18n/processes/command/commands/preprocessing'
module I18n::Processes
  module Command
    module Commands
      module Missing
        include Command::Collection
        include Command::Commands::Preprocessing

        missing_types = I18n::Processes::MissingKeys.missing_keys_types
        arg :missing_types,
            '-t',
            "--types #{missing_types * ','}",
            Array,
            "Filter by types: #{missing_types * ', '}",
            parser: OptionParsers::Enum::ListParser.new(
              missing_types,
              proc do |invalid, valid|
                "{:one =>'invalid type: #{invalid}. valid: #{valid}.', :other =>'unknown types: #{invalid}. valid: #{valid}.'}"
              end
            )

        cmd :missing,
            pos:  '[locale ...]',
            desc: 'show missing translations',
            args: [:locales, :out_format, :missing_types, ['-p', '--path PATH', 'Destination path', default: 'tmp/missing_keys']]

        def missing(opt = {})
          translated_locales = opt[:locales].reject{|x| x == base_locale}
          translated_locales.each do |locale|
            $stderr.puts Rainbow("#{base_locale} to #{locale}\n").green
            preprocessing({:locales => [locale] })
            changed_keys(locale)
            missing_keys = spreadsheet_report.find_missing(locale)
            missing_count = missing_keys.count
            if missing_count.zero?
              spreadsheet_report.translated_files(locale)
              spreadsheet_report.origin_dic(locale)
            else
              $stderr.puts Rainbow("#{missing_count} keys need to be translated to #{locale}").red.bright
              spreadsheet_report.missing_report(locale)
            end
          end
        end

        cmd :translate_missing,
            pos:  '[locale ...]',
            desc: 'translate missing keys with Google Translate',
            args: [:locales, :locale_to_translate_from, arg(:out_format).from(1)]

        def translate_missing(opt = {})
          missing    = i18n.missing_diff_forest opt[:locales], opt[:from]
          translated = i18n.google_translate_forest missing, opt[:from]
          i18n.data.merge! translated
          log_stderr "Translated #{translated.leaves.count} keys"
          print_forest translated, opt
        end

        # cmd :add_missing,
        #     pos:  '[locale ...]',
        #     desc: 'add missing keys to locale data',
        #     args: [:locales, :out_format, arg(:value) + [{ default: '%{value_or_default_or_human_key}' }],
        #            ['--nil-value', 'Set value to nil. Takes precedence over the value argument.']]

        # def add_missing(opt = {}) # rubocop:disable Metrics/AbcSize
        #   [ # Merge base locale first, as this may affect the value for the other locales
        #     [i18n.base_locale] & opt[:locales],
        #     opt[:locales] - [i18n.base_locale]
        #   ].reject(&:empty?).each_with_object(i18n.empty_forest) do |locales, added|
        #     forest = i18n.missing_keys(locales: locales, **opt.slice(:types, :base_locale))
        #                  .set_each_value!(opt[:'nil-value'] ? nil : opt[:value])
        #
        #     # call method I18n::Processes::Data::FileSystemBase merge! to generate file
        #     i18n.data.merge! forest
        #     # call method I18n::Processes::Data::Tree::Nodes::Siblings merge! to generate file
        #     added.merge! forest
        #   end.tap do |added|
        #     log_stderr "{:one => 'Added #{added.leaves.count} key', :other => 'Added #{added.leaves.count} keys'}"
        #     print_forest added, opt
        #   end
        # end
      end
    end
  end
end
