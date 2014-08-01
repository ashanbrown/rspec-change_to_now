# RSpec::ChangeTo [![Build Status](https://travis-ci.org/dontfidget/rspec-change_to_now.png)](https://travis-ci.org/dontfidget/rspec-change_to_now)

RSpec::ChangeTo provides the `to`, `not_to` and `to_not` methods to `change` matcher to describe changes in the conditions

## Installation

Add this line to your application's Gemfile:

    gem 'rspec-change_to'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rspec-change_to_now

And require it as:

    require 'rspec/change_to_now'

## Usage

Use the `to_now` and `not_to_now` methods to make assertions about the effect of an rspec `change` block.

    x = 1
    expect { x += 1 }.to change { x }.to eq 2

and

    x = 1
    expect { x += 1 }.to change { x }.not_to eq 3

`to` will check both that the matcher is *does not* match prior to the change and that it *does* match after the change.  `not_to` and `to_note` will both do the opposite, ensuring that the matcher fails prior to the change, and matches only after the change. 

A few (or `not_to_now` or `to_not_now`) 

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
