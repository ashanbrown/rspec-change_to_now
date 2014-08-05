require 'rspec/core'
require 'rspec/expectations'

module RSpec
  module ChangeToNow::Matchers
    # Decorator that wraps a matcher and raises a syntax error if the matcher is not a matcher.
    #
    # @api private
    class MatcherOnly < RSpec::Matchers::MatcherDelegator
      # Forward messages on to the wrapped matcher, first verifying that this really is a matcher.
      def method_missing(method, *args)
        raise SyntaxError, "expected a matcher as an argument but got: #{base_matcher.inspect}" unless Matchers.is_a_matcher?(base_matcher)
        base_matcher.send(method, *args)
      end

      def description(*args)
        base_matcher.description(*args)
      end
    end
  end
end
