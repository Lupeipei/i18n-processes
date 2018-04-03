# frozen_string_literal: true

require 'i18n/processes/reports/base'
require 'fileutils'
require 'i18n/processes/path'

module I18n::Processes::Reports
  class Spreadsheet < Base
    include I18n::Processes::Path

    def missing_report(locale)
      path = 'tmp/missing_keys/'
      FileUtils::mkdir_p path  unless Dir.exist?path
      file = "#{path}missing_keys_#{locale}"
      report = File.new(file, 'w')
      report.write("# 说明：以#开头的行，表示key对应的中文翻译\n# 下一行'='左边为key，'='右边需要填上对应的#{locale}翻译： \n")
      report.write("\n\n# =======================  missing keys list =============================\n\n")
      find_missing(locale).map do |k,v|
        report.write("# #{v}")
        report.write("#{k}=#{k}\n\n")
      end
      report.close
      $stderr.puts Rainbow("missing report saved to #{file}\n").red.bright
    end

    def translated_files(locale)
      path = translated_path.first unless translated_path == []
      dic = get_dic("./tmp/#{locale}")
      FileUtils.rm_f Dir.glob("./#{path}**/**") unless Dir["./#{path}**/**"].size.zero?
      origin_files = origin_files(base_locale).flatten
      # $stderr.puts Rainbow origin_files
      origin_files.each do |origin_file|
        translated_file(origin_file,"#{path}#{locale}/",  dic)
      end
      $stderr.puts Rainbow("translated files saved to #{path}\n").green
    end

    def find_missing(locale = nil)
      path = './tmp/'
      comp_dic = get_dic(path + locale)
      base_dic = get_dic(path + base_locale)
      base_dic.select { |k,v| (base_dic.keys - comp_dic.keys).include?(k)}
    end

    ## save origin files in key = value format for next comparing

    private

    def translated_file(file, path, dic)
      translated_file = new_file(file, path)
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

    def new_file(file, path)
      sourced = source_path.first
      new_file = file.sub(sourced, path) if file.include?(sourced)
      FileUtils::mkdir_p File.dirname(new_file) unless Dir.exist?File.dirname(new_file)
      File.new(new_file, 'w')
    end

  end
end
