
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "i18n/processes/version"

Gem::Specification.new do |spec|
  spec.name          = "i18n-processes"
  spec.version       = I18n::Processes::VERSION
  spec.authors       = ["Lucia"]
  spec.email         = ["learningleadtorebirth@gmail.com"]

  spec.summary       = 'manage synced translation'
  spec.description   = <<-TEXT
i18n-processes helps you to synchronize your translation.
  TEXT
  spec.homepage      = 'https://github.com/Lupeipei/i18n-processes'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata = { 'issue_tracker' => 'https://github.com/Lupeipei/i18n-processes' } if spec.respond_to?(:metadata=)

  # if spec.respond_to?(:metadata)
  #   spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against " \
  #     "public gem pushes."
  # end

  # spec.files         = `git ls-files -z`.split("\x0").reject do |f|
  #   f.match(%r{^(test|spec|features)/})
  # end
  # spec.bindir        = "exe"
  # spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  # spec.require_paths = ["lib"]
  #
  # spec.add_development_dependency "bundler", "~> 1.16"
  # spec.add_development_dependency "rake", "~> 10.0"
  # spec.add_development_dependency "rspec", "~> 3.0"


  spec.files = `git ls-files`.split($/)
  spec.files -= spec.files.grep(%r{^(doc/|\.|spec/)}) + %w[config/i18n-processes.yml Gemfile]
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) } - %w[i18n-processes.cmd]
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport', '>= 4.0.2'
  spec.add_dependency 'ast', '>= 2.1.0'
  spec.add_dependency 'easy_translate', '>= 0.5.1'
  spec.add_dependency 'erubi'
  spec.add_dependency 'highline', '>= 1.7.3'
  spec.add_dependency 'i18n'
  spec.add_dependency 'parser', '>= 2.2.3.0'
  spec.add_dependency 'rainbow', '>= 2.2.2', '< 4.0'
  spec.add_dependency 'terminal-table', '>= 1.5.1'
  spec.add_development_dependency 'axlsx', '~> 2.0'
  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 3.3'
  spec.add_development_dependency 'rubocop', '~> 0.53.0'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'yard'
end
