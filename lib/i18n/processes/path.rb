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

  def origin_dic(locale)
    path = "#{compare_path.first}previous"
    FileUtils::mkdir_p path unless Dir.exist?path
    locales = [base_locale, locale]
    locales.each do |locale|
      origin_file = compare_path.first + locale
      previous_file = "#{path}/pre_#{locale}"
      File.delete(previous_file) if File.exist?(previous_file)
      FileUtils.cp origin_file, previous_file if File.exist?(origin_file)
    end
  end


  def changed_keys(locale)
    previous = "#{compare_path.first}previous/pre_#{base_locale}"
    if File.exist?(previous)
      current = compare_path.first + base_locale
      locale_file = compare_path.first + locale
      previous_dic = get_dic(previous)
      current_dic = get_dic(current)
      locale_dic = get_dic(locale_file)
      diff = current_dic.merge(previous_dic){|k, v1, v2| {:current => v1, :previous => v2 } unless v1 == v2 }
      diff.select!{ |k, v| v.is_a?(Hash)}
      check_changed_keys(diff,locale_dic)
    end
  end

  def check_changed_keys(diff, locale_dic)
    # log_stderr diff
    unless diff == {} || (locale_dic.keys - diff.keys == locale_dic.keys)
      print_changed_keys(diff)
      changed_keys_save(diff)
      raise Rainbow("need to update #{diff.count} keys' translation").red.bright
    end
  end

  def changed_keys_save(diff)
    file = "#{compare_path.first}changed_keys/changed_keys"
    FileUtils::mkdir_p File.dirname(file) unless Dir.exist?File.dirname(file)
    changed_keys = File.new(file, 'w')
    diff.each do |k, v|
      changed_keys.write "key: #{k}\n"
      changed_keys.write "current: #{v[:current]}"
      changed_keys.write "previous: #{v[:previous]}"
      changed_keys.write "\n"
    end
    changed_keys.close
    log_warn("changed_keys save to #{file}")
  end

  def get_dic(path)
    fail "#{path} not exist" unless File.exist?(path)
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