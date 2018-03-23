# frozen_string_literal: true

require 'i18n/processes/command/dsl'
require 'i18n/processes/command/options/common'
require 'i18n/processes/command/options/locales'
require 'i18n/processes/command/options/data'

module I18n::Processes
  module Command
    module Collection
      def self.included(base)
        base.module_eval do
          include Command::DSL
          include Command::Options::Common
          include Command::Options::Locales
          include Command::Options::Data
        end
      end
    end
  end
end
