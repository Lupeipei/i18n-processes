source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

# Specify your gem's dependencies in i18n-processes.gemspec
gemspec

platform :jruby do
  # Highline v1 does not work on JRuby 9.1.15.0:
  # https://github.com/JEG2/highline/issues/227
  gem 'highline'#, '>= 2.0.0.pre.develop.14'
end

platform :rbx do
  # https://github.com/rubinius/rubinius/issues/2632
  gem 'racc'
end

