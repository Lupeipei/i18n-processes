# frozen_string_literal: true

require 'i18n/processes/reports/base'
require 'fileutils'

module I18n::Processes::Reports
  class Spreadsheet < Base

    def missing_report(path, _opt)
      path = path.presence || 'tmp/missing_keys'
      report = File.new(path,'w')
      report.write("# 说明：以#开头的行，表示key对应的中文翻译\n# 下一行'='左边为key，'='右边需要填上对应的英文翻译： \n")
      report.write("\n\n# =======================  missing keys list =============================\n\n")
      find_missing.map do |k,v|
        report.write("# #{v}")
        report.write("#{k}=#{k}\n\n")
      end
      report.close
      $stderr.puts Rainbow("missing report saved to #{path}").green
    end

    def translated_files
      dic = get_dic('./config/locales/dictionary/en.yml')
      path = './translated/'
      FileUtils.rm_f Dir.glob("#{path}*") unless Dir["#{path}*"].size.zero?
      origin_files = Dir['./upload/zh-CN/*']
      origin_files.each do |file|
        translated_file(file, path, dic)
      end
      $stderr.puts Rainbow("translated files saved to #{path}").green
    end

    def find_missing
      path_zh = './config/locales/origin/zh-CN.yml'
      path_en = './config/locales/dictionary/en.yml'
      zh_dic = get_dic(path_zh)
      en_dic = get_dic(path_en)
      zh_dic.select {|k,v| (zh_dic.keys - en_dic.keys).include?(k)}
    end

    private


    def get_dic(path)
      {}.tap do |dic|
        File.open(path).each_line do |line|
          key = line.split('=').first
          value = line.split('=').last
          dic[key] = value
        end
      end
    end

    def translated_file(file, path, dic)
      file_name = File.basename(file)
      translated_file = File.new("#{path}#{file_name}.en", 'w')
      File.open(file).read.each_line do |line|
        if line =~ /^#/ || line == "\n" || !line.include?('.')
          translated_file.write line
        elsif line.include?('\':')
          line.gsub!(/'|,/, '')
          key = line.split(': ').first.delete(' ')
          translated_file.write("  '#{key}': '#{dic[key].chomp}',\n") if dic.key?(key)
        else
          key = line.split('=').first.delete(' ')
          translated_file.write("#{key}=#{dic[key]}") if dic.key?(key)
        end
      end
      translated_file.close
    end

  end
end
