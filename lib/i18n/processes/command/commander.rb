# frozen_string_literal: true

require 'i18n/processes/cli'
require 'i18n/processes/reports/terminal'
require 'i18n/processes/reports/spreadsheet'

module I18n::Processes
  module Command
    class Commander
      include ::I18n::Processes::Logging

      attr_reader :i18n

      # @param [I18n::Processes::BaseTask] i18n
      def initialize(i18n)
        @i18n = i18n
      end

      def run(name, opts = {})
        name = name.to_sym
        public_name = name.to_s.tr '_', '-'
        log_verbose "task: #{public_name}(#{opts.map { |k, v| "#{k}: #{v.inspect}" } * ', '})"
        if opts.empty? || method(name).arity.zero?
          send name
        else
          send name, opts
        end
      end

      protected

      def terminal_report
        @terminal_report ||= I18n::Processes::Reports::Terminal.new(i18n)
      end

      def spreadsheet_report
        @spreadsheet_report ||= I18n::Processes::Reports::Spreadsheet.new(i18n)
      end

      delegate :base_locale, :locales, :t, to: :i18n
    end
  end
end
