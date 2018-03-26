# frozen_string_literal: true

require 'i18n/processes/reports/base'
require 'fileutils'

module I18n::Processes::Reports
  class Spreadsheet < Base
    def save_report(path, _opts)
      path = path.presence || 'tmp/i18n-report.xlsx'
      p = Axlsx::Package.new
      p.use_shared_strings = true # see #159
      add_missing_sheet p.workbook
      add_all_keys_sheet p.workbook
      # add_eq_base_sheet p.workbook
      FileUtils.mkpath(File.dirname(path))
      p.serialize(path)
      $stderr.puts Rainbow("Saved to #{path}").green
    end

    private

    def add_missing_sheet(wb) # rubocop:disable Metrics/AbcSize
      forest = collapse_missing_tree! task.missing_keys
      wb.styles do |s|
        # type_cell = s.add_style alignment: { horizontal: :center }
        locale_cell = s.add_style alignment: { horizontal: :center }
        regular_style = s.add_style
        wb.add_worksheet(name: missing_title(forest)) do |sheet|
          sheet.page_setup.fit_to width: 1
          sheet.add_row [I18n.t('i18n_processes.common.locale'),
                         I18n.t('i18n_processes.common.key'), 'Zh', 'translated']
          style_header sheet
          # forest.keys do |key, node|
          #   locale = format_locale(node.root.data[:locale])
          #   # type = node.data[:type]
          #   sheet.add_row [locale, key, task.t(key)],
          #                 styles: [locale_cell, regular_style, regular_style]
          # end
          sort_by_attr!(forest_to_attr(forest)).map do |a|
            sheet.add_row [a[:locale],
                           a[:key],
                           a[:value]], styles: [locale_cell, regular_style, regular_style]
          end

        end
      end
    end

    # def add_eq_base_sheet(wb)
    #   keys = task.eq_base_keys.root_key_values(true)
    #   add_locale_key_value_table wb, keys, name: eq_base_title(keys)
    # end
    #
    def add_all_keys_sheet(wb)
      keys = task.unused_keys.root_key_values(true)
      add_locale_key_value_table wb, keys, name: unused_title(keys)
    end

    def add_locale_key_value_table(wb, keys, worksheet_opts = {})
      wb.add_worksheet worksheet_opts do |sheet|
        sheet.add_row [I18n.t('i18n_processes.common.locale'), I18n.t('i18n_processes.common.key'),
                       I18n.t('i18n_processes.common.value')]
        style_header sheet
        keys.each do |locale_k_v|
          sheet.add_row locale_k_v
        end
      end
      # $stderr.puts Rainbow("first keys: #{keys.first}").green
      # $stderr.puts Rainbow("last keys: #{keys.last}").green
    end

    def style_header(sheet)
      border_bottom = sheet.workbook.styles.add_style(border: { style: :thin, color: '000000', edges: [:bottom] })
      sheet.rows.first.style = border_bottom
    end
  end
end
