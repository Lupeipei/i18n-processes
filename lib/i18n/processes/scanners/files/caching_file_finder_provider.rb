# frozen_string_literal: true

require 'i18n/processes/scanners/files/caching_file_finder'

module I18n::Processes::Scanners::Files
  # Finds the files and provides their contents.
  #
  # @note This class is thread-safe. All methods are cached.
  # @since 0.9.0
  class CachingFileFinderProvider
    # @param exclude [Array<String>]
    def initialize(exclude: [])
      @cache = {}
      @mutex = Mutex.new
      @defaults = { exclude: exclude }
    end

    # Initialize a {CachingFileFinder} or get one from cache based on the constructor arguments.
    #
    # @param (see FileFinder#initialize)
    # @return [CachingFileFinder]
    def get(**file_finder_args)
      @cache[file_finder_args] || @mutex.synchronize do
        @cache[file_finder_args] ||= begin
          args = file_finder_args.dup
          args[:exclude] = @defaults[:exclude] + (args[:exclude] || [])
          args[:exclude].uniq!
          CachingFileFinder.new(**args)
        end
      end
    end
  end
end
