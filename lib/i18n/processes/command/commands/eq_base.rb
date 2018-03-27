# frozen_string_literal: true

require 'i18n/processes/command/collection'
module I18n::Processes
  module Command
    module Commands
      module EqBase
        include Command::Collection

        cmd :eq_base,
            pos:  '[locale ...]',
            desc: 'show translations equal to base value',
            args: %i[locales out_format]

        def eq_base(opt = {})
          print_forest i18n.eq_base_keys(opt), opt, :eq_base_keys
        end
      end
    end
  end
end
