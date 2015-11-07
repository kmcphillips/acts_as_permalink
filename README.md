# [Acts as Permalink](https://github.com/kmcphillips/acts_as_permalink)

[![Build Status](https://travis-ci.org/kmcphillips/acts_as_permalink.svg?branch=master)](https://travis-ci.org/kmcphillips/acts_as_permalink)

Manages permalink field on an ActiveRecord model to be used in place of the id field in Rails.

Written by [Kevin McPhillips](https://github.com/kmcphillips) ([github@kevinmcphillips.ca](mailto:github@kevinmcphillips.ca))


## Installation

Using bundler, add to the Gemfile:

```ruby
gem 'acts_as_permalink'
```

Or stand alone:

```
$ gem install acts_as_permalink
```

## Requirements

* Ruby 2.0 or higher
* Rails 4.0 or higher


## Usage

This gem works with ActiveRecord, and by convention looks for a `title` method and a `permalink` string field on the model:

And then just call it in your model:

```ruby
class Post < ActiveRecord::Base
  acts_as_permalink
end
```

You can then use your link helpers normally:

```ruby
post_path(@post) # "/post/the_name_of_post_here"
```

The `title` and `permalink` fields can be overridden with the following options:

    from:        :title       # Name of the active record column or function used to generate the permalink
    to:          :permalink   # Name of the column where the permalink will be stored
    max_length:  60           # Maximum number of characters the permalink will be
    underscore:  false        # Prefer using the `_` character as a replacement over the default `-`

So, for example you have want to store your permalink in a column called `path_name` and you want to generate your permalink using first and last name, and you want to restrict it to 40 characters, your model would look like:

```ruby
class User < ActiveRecord::Base
  acts_as_permalink from: :full_name, to: :path, max_length: 40

  def full_name
    [first_name, last_name].join(" ")
  end
end
```


## Tests

```
$ bundle exec rspec
```


## Changelog

* 1.0.3  --  Update tests to use DatabaseCleaner, and bump some dependency versions.

* 1.0.2  --  Use `ActiveSupport::Inflector.transliterate` to convert accented letters to simple ASCII letters.

* 1.0.1  --  Fixed a bug where instance methods were being included globally, rather than on calling the class macro.

* 1.0.0  --  Internal refactor. Require Rails 4.0 or above and Ruby 2.0 or above. Full release, only took 6 years!

* 0.6.0  --  Switch default replacement character to a dash, but allow the `underscore: true` property to go back to the old format

* 0.5.0  --  Fix bugs in `max_length` property which would sometimes allow the permalink to be longer than the value
             Use `where().first` over `send("find_by_#{ column }")`

* 0.4.2  --  Update rspec to new expect() syntax

* 0.4.1  --  Documentation improvements.

* 0.4.0  --  Rails 4 support.

* 0.3.2  --  Fixed regression in STI support.

* 0.3.1  --  Rails 3.2 support.

* 0.3.0  --  Fixed collision problem with single table inheritance models. Removed dependency on andand gem.


## Contributing

1. Fork it ( https://github.com/kmcphillips/acts_as_permalink/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
