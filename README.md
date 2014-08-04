# RSpec::ChangeToNow [`rdoc`](http://rubydoc.info/github/dontfidget/rspec-change_to_now/) [![Build Status](https://travis-ci.org/dontfidget/rspec-change_to_now.png)](https://travis-ci.org/dontfidget/rspec-change_to_now) [![Code Climate](https://codeclimate.com/github/dontfidget/rspec-change_to_now/badges/gpa.svg)](https://codeclimate.com/github/dontfidget/rspec-change_to_now) [![Dependency Status](https://gemnasium.com/dontfidget/rspec-change_to_now.svg)](https://gemnasium.com/dontfidget/rspec-change_to_now) [![Gem Version](https://badge.fury.io/rb/rspec-change_to_now.svg)](http://badge.fury.io/rb/rspec-change_to_now) [![Coverage Status](https://coveralls.io/repos/dontfidget/rspec-change_to_now/badge.png?branch=master)](https://coveralls.io/r/dontfidget/rspec-change_to_now?branch=master) [![Test Coverage](https://codeclimate.com/github/dontfidget/rspec-change_to_now/badges/coverage.svg)](https://codeclimate.com/github/dontfidget/rspec-change_to_now)

RSpec::ChangeTo adds the `to_now` and `not_to_now` methods to `change` matcher to describe how executing a block should change a matcher expectation.

## Usage

Use the `to_now` and `not_to_now` (or `not_to`, for short) methods to make assertions about the effect of an rspec `change` block:

```ruby
    expect { @x = 1 }.to change { @x }.to_now eq 1
```

or

```ruby
    expect { @x = 1 }.to change { @x }.not_to eq 2
```

The method `to_now` will check both that the matcher *does not* match prior to the change and that it *does* match after the change.  The method `not_to_now` (`not_to` for short) will do the opposite, ensuring that the matcher matches prior to the change, and fails only after the change.  All methods will ensure that a change actually takes place. 

Also supported are aliases for those who don't want to split their infinitives and for those who would like to differently split them:

* `to_now` can also be called as `now_to`
* `not_to_now` can also be called `not_to`, `to_not`, `to_not_now` and `not_now_to` 

## Overriding default RSpec behavior

You can force the rspec `change` matcher to always use `to_now` instead of `to` by setting:

```ruby
RSpec::Matchers::ChangeToNow.override_to = true
```


## Testing without preconditions

There are a couple of ways to prevent precondition checks if you don't want them for a particular expectation:

1. Use `with_final_result` instead of `to_now` to check your results.  e.g.

    ```ruby
    it "initializes an empty list" do
      list = nil
      expect { list = [] }.with_final_result satisfy(&:empty)  
    end
    ```

1. Explicitly specify a `from` value or matcher, either before or after your `to_now` statement:

    ```ruby
    it "initializes an empty list" do
      list = nil
      expect { list = [] }.from(nil).to_now satisfy(&:empty)
      list = nil
      expect { list = [] }.to_now satisfy(&:empty).from(nil)  
    end
    ```

## Installation

Add this line to your application's Gemfile:

    gem 'rspec-change_to_now'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rspec-change_to_now

And require it as:

    require 'rspec/change_to_now'

## Why is this useful?

`change { }.from().to()` adds expectation of pre- and post-conditions for a change, but it is restricted only to object values.  With `to_now`, you can write

```ruby
    list = []
    expect { list << :a }.to change { list }.to_now include :a
```

 whereas previously you would have to fully specify the original and final values of the list: 

```ruby
    list = []
    expect { list << :a }.to change { list }.from([]).to([:a])
```

While that may not seem like a big deal, the real values comes in more complex statements like:

```ruby
    person = Person.create(name: 'Taylor')
    expect { person.siblings.create(name: 'Sam') }.to change { Person.all.map(&:name) }.to_now include('Taylor')
```

Arguably, I should be injecting some dependencies here instead of relying on globals, but Rails code doesn't always look like that.  I'm looking forward to playing around with this and seeing if it really helps simplify specs.  I'd love to hear your feedback.

## Additional Matchers Provided

This gem also provides some additional matchers as detailed below.

### `negate(&block)`

This gem also introduces the `negate` matcher, which negates an existing matcher.  You can use it like so:


```ruby
    expect(1).to negate(ne(1))
```

While it doesn't read every well, it serves an internal purpose, allowing a very simple implementation of `to_now` using composable matcher inputs to the `from` and `to` methods as [added in rspec 3.0](http://myronmars.to/n/dev-blog/2014/01/new-in-rspec-3-composable-matchers).

### `detect(&block)`

This gem also adds the `detect` matcher, which behaves like the `include` matcher when passed a `satisfy` matcher created using the given block.  You can use it like so:


```ruby
    list = []
    expect { list << 2 }.to change { list }.to detect(&:even?)
```

This is the same as:

```ruby
    list = []
    expect { list << 2 }.to change { list }.to include satisfy(&:even?)
```

A more interesting use might be:

```ruby
    person = Person.create(name: 'Taylor')
    expect { person.siblings.create(name: 'Sam') }.to change {
      Person.all
    }.to_now detect { |person|
      person.name == 'Taylor'
    }
```

`detect` behaves exactly like `include` when it is not passed a block and will raise an exception if passed both expected items/matchers and a block.

### `detect(&block)`

This gem also adds the `detect` matcher, which behaves like the `include` matcher when passed a `satisfy` matcher created using the given block.  You can use it like so:


```ruby
    list = []
    expect { list << 2 }.to change { list }.to detect(&:even?)
```

This is the same as:

```ruby
    list = []
    expect { list << 2 }.to change { list }.to include satisfy(&:even?)
```

A more interesting use might be:

```ruby
    person = Person.create(name: 'Taylor')
    expect { person.siblings.create(name: 'Sam') }.to change {
      Person.all
    }.to_now detect { |person|
      person.name == 'Taylor'
    }
```

`detect` behaves exactly like `include` when it is not passed a block and will raise an exception if passed both expected items/matchers and a block.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
