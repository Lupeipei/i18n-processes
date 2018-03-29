# I18n::Processes

设置目标语言，根据给到的指定格式的中文文档，输出相对应的翻译文件。

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'i18n-processes'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install i18n-processes

## Usage

- 将需要翻译的中文文件夹放入source/目录下
- 运行：bundle exec i18n-processes preprocessing
- 运行：bundle exec i18n-processes missing
- 在translated/下，生成同名的文件夹，内含对应的翻译文件


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/i18n-processes.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
