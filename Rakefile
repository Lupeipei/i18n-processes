require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

task :irb do
  require 'i18n/processes'
  require 'i18n/processes/commands'
  I18n::Processes::Commands.new(I18n::Processes::BaseProcess.new).irb
end
