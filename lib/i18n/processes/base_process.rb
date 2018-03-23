# frozen_string_literal: true

require 'i18n/processes/command_error'
require 'i18n/processes/split_key'
require 'i18n/processes/key_pattern_matching'
require 'i18n/processes/logging'
require 'i18n/processes/plural_keys'
require 'i18n/processes/references'
require 'i18n/processes/html_keys'
require 'i18n/processes/used_keys'
require 'i18n/processes/ignore_keys'
require 'i18n/processes/missing_keys'
require 'i18n/processes/unused_keys'
require 'i18n/processes/google_translation'
require 'i18n/processes/locale_pathname'
require 'i18n/processes/locale_list'
require 'i18n/processes/string_interpolation'
require 'i18n/processes/data'
require 'i18n/processes/configuration'
require 'i18n/processes/stats'

module I18n::Processes
  class BaseProcess
    include SplitKey
    include KeyPatternMatching
    include PluralKeys
    include References
    include HtmlKeys
    include UsedKeys
    include IgnoreKeys
    include MissingKeys
    include UnusedKeys
    include GoogleTranslation
    include Logging
    include Configuration
    include Data
    include Stats

    def initialize(config = {})
      self.config = config || {}
    end

    def inspect
      "#{self.class.name}#{config_for_inspect}"
    end
  end
end
