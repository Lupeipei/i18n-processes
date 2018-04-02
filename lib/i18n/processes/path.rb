# frozen_string_literal: true

module I18n::Processes:: Path

  def origin_files(locale)
    source = locale == base_locale ? source_path : translation_path[locale.to_sym]
    [].tap do |file|
      source.map do |path|
        path = path[-1] == '/' ? path : path + '/'
        group = Dir.glob("#{path}**/**")
        file << group.reject { |x| File.directory?(x) }
      end
    end
  end

  def source_path
    config_file[:data][:source]
  end

  def translation_path
    config_file[:data][:translation]
  end

  def translated_path
    config_file[:data][:translated]
  end

  def config_file
    file = Dir.glob(File.join('**', '*.yml')).select{ |x| x.include?'i18n-processes' }
    YAML.load_file(file.first).deep_symbolize_keys unless file.empty?
  end
end