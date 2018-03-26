# frozen_string_literal: true

require 'i18n/processes/command/dsl'
require 'i18n/processes/command/collection'
require 'i18n/processes/command/commands/health'
require 'i18n/processes/command/commands/missing'
require 'i18n/processes/command/commands/usages'
require 'i18n/processes/command/commands/eq_base'
require 'i18n/processes/command/commands/data'
require 'i18n/processes/command/commands/tree'
require 'i18n/processes/command/commands/meta'
require 'i18n/processes/command/commands/xlsx'
require 'i18n/processes/command/commands/preprocessing'
require 'i18n/processes/command/commander'

module I18n::Processes
  class Commands < Command::Commander
    include Command::DSL
    include Command::Commands::Health
    include Command::Commands::Missing
    include Command::Commands::Usages
    include Command::Commands::EqBase
    include Command::Commands::Data
    include Command::Commands::Tree
    include Command::Commands::Meta
    include Command::Commands::XLSX
    include Command::Commands::Preprocessing

    require 'highline/import'
  end
end
