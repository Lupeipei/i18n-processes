# frozen_string_literal: true

module I18n::Processes
  module LocalePathname
    class << self
      def replace_locale(path, from, to)
        path && path.gsub(path_locale_re(from), to)
      end

      private

      def path_locale_re(locale)
        (@path_locale_res ||= {})[locale] ||= %r{(?<=^|[/.])#{locale}(?=[/.])}
      end
    end
  end
end
