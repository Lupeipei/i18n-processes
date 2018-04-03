# frozen_string_literal: true

require 'i18n/processes/command/collection'
module I18n::Processes
  module Command
    module Commands
      module Usages
        include Command::Collection

        # arg :strict,
        #     '--[no-]strict',
        #     'Avoid inferring dynamic key usages such as t("cats.#{cat}.name"). Takes precedence over the config setting if set.'
        #
        # cmd :find,
        #     pos:  '[pattern]',
        #     desc: 'show where keys are used in the code',
        #     args: %i[out_format pattern strict]
        #
        # def find(opt = {})
        #   opt[:filter] ||= opt.delete(:pattern) || opt[:arguments].try(:first)
        #   result = i18n.used_tree(strict: opt[:strict], key_filter: opt[:filter].presence, include_raw_references: true)
        #   print_forest result, opt, :used_keys
        # end
        #
        # cmd :unused,
        #     pos:  '[locale ...]',
        #     desc: 'show unused translations',
        #     args: %i[locales out_format strict]
        #
        # def unused(opt = {})
        #   forest = i18n.unused_keys(opt.slice(:locales, :strict))
        #   print_forest forest, opt, :unused_keys
        #   :exit_1 unless forest.empty?
        # end
        #
        # cmd :remove_unused,
        #     pos:  '[locale ...]',
        #     desc: 'remove unused keys',
        #     args: %i[locales out_format strict confirm]
        #
        # def remove_unused(opt = {})
        #   unused_keys = i18n.unused_keys(opt.slice(:locales, :strict))
        #   if unused_keys.present?
        #     terminal_report.unused_keys(unused_keys)
        #     confirm_remove_unused!(unused_keys, opt)
        #     removed = i18n.data.remove_by_key!(unused_keys)
        #     log_stderr "Removed #{unused_keys.leaves.count} keys"
        #     print_forest removed, opt
        #   else
        #     log_stderr Rainbow("No unused keys to remove").green.bright
        #   end
        # end

        private

        def confirm_remove_unused!(unused_keys, opt)
          return if ENV['CONFIRM'] || opt[:confirm]
          locales = Rainbow(unused_keys.flat_map { |root| root.key.split('+') }.sort.uniq * ', ').bright
          msg     = [
            Rainbow("{:one =>'#{unused_keys.leaves.count} translation will be removed from #{locales}.', :other =>'#{unused_keys.leaves.count} translation will be removed from #{locales}.'}").red,
            Rainbow("Continue?").yellow,
            Rainbow('(yes/no)').yellow
          ].join(' ')
          exit 1 unless agree msg
        end
      end
    end
  end
end
