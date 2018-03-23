# frozen_string_literal: true

module I18n::Processes::Logging
  module_function

  MUTEX = Mutex.new
  PROGRAM_NAME = File.basename($PROGRAM_NAME)

  def warn_deprecated(message)
    log_stderr Rainbow("#{program_name}: [DEPRECATED] #{message}").yellow.bright
  end

  def log_verbose(message = nil)
    log_stderr Rainbow(message || yield).blue.bright if ::I18n::Processes.verbose?
  end

  def log_warn(message)
    log_stderr Rainbow("#{program_name}: [WARN] #{message}").yellow
  end

  def log_error(message)
    log_stderr Rainbow("#{program_name}: #{message}").red.bright
  end

  def log_stderr(*args)
    MUTEX.synchronize do
      # 1. We don't want output from different threads to get intermixed.
      # 2. StringIO is currently not thread-safe (blows up) on JRuby:
      # https://github.com/jruby/jruby/issues/4417
      $stderr.puts(*args)
    end
  end

  def program_name
    PROGRAM_NAME
  end
end
