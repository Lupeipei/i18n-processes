# frozen_string_literal: true

require 'i18n/processes/command/collection'
module I18n::Processes
  module Command
    module Commands
      module Tree
        include Command::Collection
        include I18n::Processes::KeyPatternMatching

        # cmd :tree_translate,
        #     pos:  '[tree (or stdin)]',
        #     desc: 'Google Translate a tree to root locales',
        #     args: [:locale_to_translate_from, arg(:data_format).from(1)]
        #
        # def tree_translate(opts = {})
        #   forest = forest_pos_or_stdin!(opts)
        #   print_forest i18n.google_translate_forest(forest, opts[:from]), opts
        # end
        #
        # cmd :tree_merge,
        #     pos:  '[[tree] [tree] ... (or stdin)]',
        #     desc: 'merge trees',
        #     args: %i[data_format nostdin]
        #
        # def tree_merge(opts = {})
        #   print_forest merge_forests_stdin_and_pos!(opts), opts
        # end
        #
        # cmd :tree_filter,
        #     pos:  '[pattern] [tree (or stdin)]',
        #     desc: 'filter tree by key pattern',
        #     args: %i[data_format pattern]
        #
        # def tree_filter(opts = {})
        #   pattern = arg_or_pos! :pattern, opts
        #   forest  = forest_pos_or_stdin! opts
        #   unless pattern.blank?
        #     pattern_re = i18n.compile_key_pattern(pattern)
        #     forest     = forest.select_keys { |full_key, _node| full_key =~ pattern_re }
        #   end
        #   print_forest forest, opts
        # end
        #
        # cmd :tree_rename_key,
        #     pos:  'KEY_PATTERN NAME [tree (or stdin)]',
        #     desc: 'rename tree node',
        #     args: [['-k', '--key KEY_PATTERN', 'Full key (pattern) to rename. Required'],
        #            ['-n', '--name NAME', 'New name, interpolates original name as %{key}. Required'],
        #            :data_format]
        #
        # def tree_rename_key(opt = {})
        #   warn_deprecated 'Use tree-mv instead.'
        #   key    = arg_or_pos! :key, opt
        #   name   = arg_or_pos! :name, opt
        #   forest = forest_pos_or_stdin! opt
        #   fail CommandError, 'pass full key to rename (-k, --key)' if key.blank?
        #   fail CommandError, 'pass new name (-n, --name)' if name.blank?
        #   forest.rename_each_key!(key, name)
        #   print_forest forest, opt
        # end
        #
        # arg :all_locales,
        #     '-a',
        #     '--all-locales',
        #     'Do not expect key patterns to start with a locale, instead apply them to all locales implicitly.'
        #
        # cmd :tree_mv,
        #     pos: 'FROM_KEY_PATTERN TO_KEY_PATTERN [tree (or stdin)]',
        #     desc: 'rename/merge/remove the keys matching the given pattern',
        #     args: %i[data_format all_locales]
        # def tree_mv(opt = {})
        #   fail CommandError, 'requires FROM_KEY_PATTERN and TO_KEY_PATTERN' if opt[:arguments].size < 2
        #   from_pattern = opt[:arguments].shift
        #   to_pattern = opt[:arguments].shift
        #   forest = forest_pos_or_stdin!(opt)
        #   forest.mv_key!(compile_key_pattern(from_pattern), to_pattern, root: !opt[:'all-locales'])
        #   print_forest forest, opt
        # end
        #
        # cmd :tree_subtract,
        #     pos:  '[[tree] [tree] ... (or stdin)]',
        #     desc: 'tree A minus the keys in tree B',
        #     args: %i[data_format nostdin]
        #
        # def tree_subtract(opt = {})
        #   forests = forests_stdin_and_pos! opt, 2
        #   forest  = forests.reduce(:subtract_by_key) || empty_forest
        #   print_forest forest, opt
        # end
        #
        # cmd :tree_set_value,
        #     pos:  '[VALUE] [tree (or stdin)]',
        #     desc: 'set values of keys, optionally match a pattern',
        #     args: %i[value data_format nostdin pattern]
        #
        # def tree_set_value(opt = {})
        #   value       = arg_or_pos! :value, opt
        #   forest      = forest_pos_or_stdin!(opt)
        #   key_pattern = opt[:pattern]
        #   fail CommandError, 'pass value (-v, --value)' if value.blank?
        #   forest.set_each_value!(value, key_pattern)
        #   print_forest forest, opt
        # end
        #
        # cmd :tree_convert,
        #     pos:  '[tree (or stdin)]',
        #     desc: 'convert tree between formats',
        #     args: [arg(:data_format).dup.tap { |a| a[0..1] = ['-f', '--from FORMAT'] },
        #            arg(:out_format).dup.tap { |a| a[0..1] = ['-t', '--to FORMAT'] }]
        #
        # def tree_convert(opt = {})
        #   forest = forest_pos_or_stdin! opt.merge(format: opt[:from])
        #   print_forest forest, opt.merge(format: opt[:to])
        # end
      end
    end
  end
end
