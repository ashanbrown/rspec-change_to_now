# RSpec::ChangeToNow [`rdoc`](http://rubydoc.info/github/dontfidget/rspec-change_to_now/) [![Build Status](https://travis-ci.org/dontfidget/rspec-change_to_now.png)](https://travis-ci.org/dontfidget/rspec-change_to_now) [![Code Climate](https://codeclimate.com/github/dontfidget/rspec-change_to_now/badges/gpa.svg)](https://codeclimate.com/github/dontfidget/rspec-change_to_now) [![Dependency Status](https://gemnasium.com/dontfidget/rspec-change_to_now.svg)](https://gemnasium.com/dontfidget/rspec-change_to_now) [![Gem Version](https://badge.fury.io/rb/rspec-change_to_now.svg)](http://badge.fury.io/rb/rspec-change_to_now) [![Coverage Status](https://coveralls.io/repos/dontfidget/rspec-change_to_now/badge.png?branch=master)](https://coveralls.io/r/dontfidget/rspec-change_to_now?branch=master) [![Test Coverage](https://codeclimate.com/github/dontfidget/rspec-change_to_now/badges/coverage.svg)](https://codeclimate.com/github/dontfidget/rspec-change_to_now)

RSpec::ChangeTo adds the `to_now` and `not_to_now` methods to `change` matcher to describe how executing a block should change a matcher expectation.

## Usage

Use the `to_now` and `not_to_now` (or `not_to`, for short) methods to make assertions about the effect of an rspec `change` block rather than just the final state:

```ruby
    expect { @x -= [1] }.to change { @x }.not_to include 1
```

Conversely, an example like this, which passes on rspec 3.0, would fail:

```ruby
@x = [1]  
expect { @x << 1 }.to change { @x }.to_now include 1
```

Also supported are aliases for those who don't want to split their infinitives and for those who would like to differently split them:

* `to_now` can also be called as `now_to`
* `not_to_now` can also be called `not_to`, `to_not`, `to_not_now` and `not_now_to` 

## How *exactly* does it work?

The method `to_now` will check both that the expected value *does not* match prior to the change and that it *does* match after the change.  The method `not_to_now` (`not_to` for short) will do the opposite, ensuring that the expected value does matche prior to the change, and fails only after the change.  Both methods will ensure that a change actually takes place.

## Globally overriding default RSpec behavior for `to` with `to_now`

You can force the rspec `change` matcher to always use `to_now` instead of `to` by setting:

```ruby
RSpec::ChangeToNow.override_to = true
```

## Testing without preconditions

While I'd assert that in most conditions, the automatic precondition checks introduced by `to_now` would be helpful, you may find yourself wanting to disable them for some expectations.  Here are a couple of ways to prevent precondition checks:

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

When passed object values as expectations, `change { }.from().to()` fails as if it has pre- and post-condition checks.  However, when a passed matcher to `to`, it will not check the inverse condition prior to the change.  With `to_now`, you can write:

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

Finally, *change_to_now* causes inferred pre-condition tests, to be explicitly reported.  For example,

```ruby
number = 2
expect {
  number += 1
}.to change { number }.to_now 2
```

will report:
 
    expected result to have initially passed ~(match 2), but was 2
    
If set up *change_to_now* to_now to globally override `change {}. to`, then even `to` will report this way.

## Additional Matchers Provided: *negate*, *detect*, *matcher_only* and *as_matcher*  

This gem also provides some additional matchers as detailed below.  Only the `detect` matcher is automatically added to the rspec DSL when `rspec/change_to_now` is required.  To get the other matchers, add this line to your `spec_helper.rb`:

```ruby
# spec_helper.rb
RSpec.configure { |c|.include RSpec::ChangeToNow::Matchers::DSL }
```

* `negate(&block)` *(optional)*

    This gem also introduces the `negate` matcher, which negates an existing matcher.  You can use it like so:


    ```ruby
        expect(1).to negate(ne(1))
    ```
    
    While it doesn't read every well, it serves an internal purpose, allowing a very simple implementation of `to_now` using composable matcher inputs to the `from` and `to` methods as [added in rspec 3.0](http://myronmars.to/n/dev-blog/2014/01/new-in-rspec-3-composable-matchers).
    
* `detect(&block)`

    The `detect` matcher behaves like the `include` matcher when passed a `satisfy` matcher created using the given block.  You can use it like so:
    
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

* `matcher_only(matcher)` *(optional)*

    The `match_only` matcher just passes the given matcher through unless it is not a matcher, in which case it raises a syntax error.  While this would pass:

    ```ruby
        expect(1).to matcher_only(eq(1))
    ```
    
    this would fail with a syntax error:
    
    ```ruby
        expect(1).to matcher_only(1)
    ```
    
* `as_matcher(expected)` *(optional)*

    The `as_matcher` matcher just passes the given matcher through unless it is not a matcher, in which case it returns a new matcher created using `match(expected)`.  So, for example, this would work:
    
    ```ruby
        expect(1).to as_matcher(1)
    ```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
