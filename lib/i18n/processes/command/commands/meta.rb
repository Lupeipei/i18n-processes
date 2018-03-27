# frozen_string_literal: true

require 'i18n/processes/command/collection'
module I18n::Processes
  module Command
    module Commands
      module Meta
        include Command::Collection

        cmd :config,
            pos:  '[section ...]',
            desc: 'display i18n-processes configuration'

        def config(opts = {})
          cfg = i18n.config_for_inspect
          cfg = cfg.slice(*opts[:arguments]) if opts[:arguments].present?
          cfg = cfg.to_yaml
          cfg.sub!(/\A---\n/, '')
          cfg.gsub!(/^([^\s-].+?:)/, Rainbow('\1').cyan.bright)
          puts cfg
        end

        cmd :gem_path, desc: 'show path to the gem'

        def gem_path
          puts I18n::Processes.gem_path
        end

        cmd :irb, desc: 'start REPL session within i18n-processes context'

        def irb
          require 'i18n/processes/console_context'
          ::I18n::Processes::ConsoleContext.start
        end
      end
    end
  end
end
