# frozen_string_literal: true

require 'i18n/processes/command/collection'
module I18n::Processes
  module Command
    module Commands
      module Missing
        include Command::Collection

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
            args: [:locales, :out_format, :missing_types, ['-p', '--path PATH', 'Destination path', default: 'tmp/missing_keys.xlsx']]

        def missing(opt = {})
          forest = i18n.missing_keys(opt.slice(:locales, :base_locale, :types))
          missing_count = forest.leaves.count
          print_forest forest, opt, :missing_keys unless forest.empty?
          # :exit_1 unless forest.empty?
          # generate missing key files
          begin
            require 'axlsx'
          rescue LoadError
            message = %(For spreadsheet report please add axlsx gem to Gemfile:\ngem 'axlsx', '~> 2.0')
            log_stderr Rainbow(message).red.bright
            exit 1
          end
          # $stderr.puts Rainbow("path: #{opt[:path]}").green
          spreadsheet_report.save_report opt[:path], opt.except(:path) unless missing_count.zero?
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

        cmd :add_missing,
            pos:  '[locale ...]',
            desc: 'add missing keys to locale data',
            args: [:locales, :out_format, arg(:value) + [{ default: '%{value_or_default_or_human_key}' }],
                   ['--nil-value', 'Set value to nil. Takes precedence over the value argument.']]

        def add_missing(opt = {}) # rubocop:disable Metrics/AbcSize
          # $stderr.puts Rainbow("missing: #{opt}").green
          [ # Merge base locale first, as this may affect the value for the other locales
            [i18n.base_locale] & opt[:locales],
            opt[:locales] - [i18n.base_locale]
          ].reject(&:empty?).each_with_object(i18n.empty_forest) do |locales, added|
            forest = i18n.missing_keys(locales: locales, **opt.slice(:types, :base_locale))
                         .set_each_value!(opt[:'nil-value'] ? nil : opt[:value])
            $stderr.puts Rainbow("forest_parent: #{forest.parent}").green # forest的parent为nil
            $stderr.puts Rainbow("forest_list: #{forest.list.class}").green
            $stderr.puts Rainbow("forest_list: #{forest.list.first.key_to_node}").green # node, yes, list是一个nodes

            # call method I18n::Processes::Data::FileSystemBase merge! to generate file
            i18n.data.merge! forest
            # call method I18n::Processes::Data::Tree::Nodes::Siblings merge! to generate file
            added.merge! forest
          end.tap do |added|
            log_stderr "{:one => 'Added #{added.leaves.count} key', :other => 'Added #{added.leaves.count} keys'}"
            print_forest added, opt
          end
        end
      end
    end
  end
end
