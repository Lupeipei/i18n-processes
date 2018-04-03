# frozen_string_literal: true

module I18n::Processes:: Path

  def origin_files(locale)
    if source_path == []
      fail "please check the path for origin baselocale files"
    elsif translation_path == []
      fail "please check the path for translation files"
    else
      source = locale == base_locale ? source_path : translation_path[locale.to_sym]
      [].tap do |file|
        source.map do |path|
          path = path[-1] == '/' ? path : path + '/'
          group = Dir.glob("#{path}**/**")
          file << group.reject { |x| File.directory?(x) }
        end
      end
    end
  end

  def origin_dic
    path = "#{compare_path.first}previous"
    FileUtils::mkdir_p path unless Dir.exist?path
    origin_file = compare_path + base_locale
    previous_file = "#{path}/pre_#{base_locale}"
    File.delete(previous_file) if File.exist?(previous_file)
    FileUtils.cp origin_file, previous_file if File.exist?(origin_file)
  end

  def get_dic(path)
    {}.tap do |dic|
      File.open(path).each_line do |line|
        key = line.split('=').first
        value = line.split('=').last
        dic[key] = value
      end
    end
  end

  def source_path
    config_file[:data][:source] ||= []
  end

  def translation_path
    config_file[:data][:translation] ||= []
  end

  def translated_path
    config_file[:data][:translated] ||= []
  end

  def compare_path
    config_file[:data][:compare] ||= ['tmp/']
  end

  def config_file
    file = Dir.glob(File.join('**', '*.yml')).select{ |x| x.include?'i18n-processes' }
    YAML.load_file(file.first).deep_symbolize_keys unless file.empty?
  end
end