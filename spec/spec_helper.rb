require 'rspec/change_to_now'
require 'rspec/mocks'

Dir['./spec/support/**/*'].each {|f| require f}

class NullFormatter
  private
  def method_missing(method, *args, &block)
    # ignore
  end
end

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.order = 'random'
end
