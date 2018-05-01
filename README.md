# Todoable

The todoable gem provides methods for working with a to-do list.  To-do lists can be created, modified, or deleted.  Each to-do list consists of a list of items.  Items can be added, deleted, and marked as finished.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'todoable'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install todoable

## Usage

Using todoable requires that the TODOABLE\_USER and TODOABLE\_PASSWORD environment variables be set.  These credentials are used to communicate with the Teachable todoable service.

Todoable includes two classes, Todoable::List and Todoable::Item.  See see lib/todoable/list.rb for a good entry point into the code.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
