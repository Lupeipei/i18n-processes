# frozen_string_literal: true

require 'i18n/processes/command/collection'
module I18n::Processes
  module Command
    module Commands
      module Meta
        include Command::Collection

        cmd :config,
            pos:  '[section ...]',
            desc: t('i18n_processes.cmd.desc.config')

        def config(opts = {})
          cfg = i18n.config_for_inspect
          cfg = cfg.slice(*opts[:arguments]) if opts[:arguments].present?
          cfg = cfg.to_yaml
          cfg.sub!(/\A---\n/, '')
          cfg.gsub!(/^([^\s-].+?:)/, Rainbow('\1').cyan.bright)
          puts cfg
        end

        cmd :gem_path, desc: t('i18n_processes.cmd.desc.gem_path')

        def gem_path
          puts I18n::Processes.gem_path
        end

        cmd :irb, desc: t('i18n_processes.cmd.desc.irb')

        def irb
          require 'i18n/processes/console_context'
          ::I18n::Processes::ConsoleContext.start
        end
      end
    end
  end
end
