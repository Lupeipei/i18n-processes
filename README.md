# I18n::Processes

设定base_local(如zh-CN)及目标语言（如en,fr）,针对指定格式的base_local文档，检查键值的变动，确保目标语言（如en,fr）文件及时更新对应的翻译文档。

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'i18n-processes', '~> 0.1.2'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install i18n-processes

## Usage

- 复制config目录下的文件i18n-processes.yml，添加到你自己的config目录下：

  ```
  $ cp $(i18n-processes gem-path)/config/i18n-processes.yml config/
  ```
  base_local默认为zh-CN.
  设置四个路径：

  - source: 原文件存放路径
  - translation: 翻译文件存放路径
  - translated：翻译后的文件存放路径
  - compare：对比文件存放路径，默认为tmp/


- 将需要翻译的中文文件夹放入设置好的目录下，比如source/
- 运行：`i18n-processes preprocessing`
  处理原文件，提取出所有的keys
- 运行：`i18n-processes missing`
  先对比上期的原始文件【如果有的话】，存在key相同，value不同的情况则会报错，输出diff：
  
  这时可以通过两种方式消除diff：
  - 删除翻译文件【比如translation/en/translated】中出现的diff.keys
  - 删除上期文件【比如tmp/previous/pre_zh-CN】中出现的diff.keys

在你设置的翻译文件存放路径下，比如translated/，会生成与原文件同结构的文件，内含对应的翻译文件


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at [i18n-processes](https://github.com/Lupeipei/i18n-processes).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
