# NumberNormalizer

This gem can help you to extract and normalize numbers from a piece of free text.

__Extraction__

   numbers expressed as digits in forms of eg.
     *1000000
     *1 000 000
     *1 120 123.12

   numbers expressed as plain words, eg.
     *"two hundred and four million one hundred ninety-five thousand" -> 204195000
     *__Note__: currently it supports English only.

__Normalization__

   Currently it will normalize all numbers to digits (Integer or Float).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'number_normalizer'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install number_normalizer

## Usage

```ruby
t = "The area is 10 123 456 square meters. The population is 1 300 000 000."
n = NumberNormalizer.new t
puts n.digit_numbers  # [10123456, 1300000000]
```

```ruby
t = "There are two hundred million five thousand people."
n = NumberNormalizer.new t
puts n.digit_numbers  # [200005000]
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/number_normalizer. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

