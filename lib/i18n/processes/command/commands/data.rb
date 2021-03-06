# frozen_string_literal: true

require 'i18n/processes/command/collection'
module I18n::Processes
  module Command
    module Commands
      module Data
        include Command::Collection

        arg :pattern_router,
            '-p',
            '--pattern_router',
            'Use pattern router: keys moved per config data.write'

        # cmd :normalize,
        #     pos:  '[locale ...]',
        #     desc: 'normalize translation data: sort and move to the right files',
        #     args: %i[locales pattern_router]

        # def normalize(opt = {})
        #   i18n.normalize_store! locales: opt[:locales],
        #                         force_pattern_router: opt[:pattern_router]
        # end
        #
        # cmd :check_normalized,
        #     pos: '[locale ...]',
        #     desc: 'verify that all translation data is normalized',
        #     args: %i[locales]
        #
        # def check_normalized(opt)
        #   non_normalized = i18n.non_normalized_paths locales: opt[:locales]
        #   terminal_report.check_normalized_results(non_normalized)
        #   :exit_1 unless non_normalized.empty?
        # end
        #
        # cmd :mv,
        #     pos: 'FROM_KEY_PATTERN TO_KEY_PATTERN',
        #     desc: 'rename/merge the keys in locale data that match the given pattern'
        # def mv(opt = {})
        #   fail CommandError, 'requires FROM_KEY_PATTERN and TO_KEY_PATTERN' if opt[:arguments].size < 2
        #   from_pattern = opt[:arguments].shift
        #   to_pattern = opt[:arguments].shift
        #   forest = i18n.data_forest
        #   results = forest.mv_key!(compile_key_pattern(from_pattern), to_pattern, root: false)
        #   i18n.data.write forest
        #   terminal_report.mv_results results
        # end
        #
        # cmd :rm,
        #     pos: 'KEY_PATTERN [KEY_PATTERN...]',
        #     desc: 'remove the keys in locale data that match the given pattern'
        # def rm(opt = {})
        #   fail CommandError, 'requires KEY_PATTERN' if opt[:arguments].empty?
        #   forest = i18n.data_forest
        #   results = opt[:arguments].each_with_object({}) do |key_pattern, h|
        #     h.merge! forest.mv_key!(compile_key_pattern(key_pattern), '', root: false)
        #   end
        #   i18n.data.write forest
        #   terminal_report.mv_results results
        # end
        #
        # cmd :data,
        #     pos:  '[locale ...]',
        #     desc: 'show locale data',
        #     args: %i[locales out_format]
        #
        # def data(opt = {})
        #   $stderr.puts Rainbow("data from here?!")
        #   print_forest i18n.data_forest(opt[:locales]), opt
        # end
        #
        # cmd :data_merge,
        #     pos:  '[tree ...]',
        #     desc: 'merge locale data with trees',
        #     args: %i[data_format nostdin]
        #
        # def data_merge(opt = {})
        #   forest = merge_forests_stdin_and_pos!(opt)
        #   merged = i18n.data.merge!(forest)
        #   print_forest merged, opt
        # end
        #
        # cmd :data_write,
        #     pos:  '[tree]',
        #     desc: 'replace locale data with tree',
        #     args: %i[data_format nostdin]
        #
        # def data_write(opt = {})
        #   forest = forest_pos_or_stdin!(opt)
        #   i18n.data.write forest
        #   print_forest forest, opt
        # end
        #
        # cmd :data_remove,
        #     pos:  '[tree]',
        #     desc: 'remove keys present in tree from data',
        #     args: %i[data_format nostdin]
        #
        # def data_remove(opt = {})
        #   removed = i18n.data.remove_by_key!(forest_pos_or_stdin!(opt))
        #   log_stderr 'Removed:'
        #   print_forest removed, opt
        # end
      end
    end
  end
end
