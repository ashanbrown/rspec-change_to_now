require 'rspec/core'
require 'rspec/expectations'

module RSpec
  module Matchers
    # Decorator that wraps a matcher and raises an error if the matcher is not a matcher.
    #
    # @api private
    class VerifyArgumentIsMatcher < MatcherDelegator
      # Forward messages on to the wrapped matcher, first verifying that this really is a matcher.
      def method_missing(method, *args)
        raise SyntaxError, "expects a matcher as an argument but got: #{base_matcher.inspect}" unless Matchers.is_a_matcher?(base_matcher)
        base_matcher.send(method, *args)
      end

      def description(*args)
        base_matcher.description(*args)
      end
    end
  end
end
