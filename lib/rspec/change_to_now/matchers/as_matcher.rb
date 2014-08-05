require 'rspec/core'
require 'rspec/expectations'

module RSpec
  module ChangeToNow::Matchers
    # Decorator that wraps a matcher and raises a syntax error if the matcher is not a matcher.
    #
    # @api private
    class AsMatcher < RSpec::Matchers::MatcherDelegator
      include RSpec::Matchers::Composable

      def initialize(expected)
        expected = RSpec::Matchers::BuiltIn::Match.new(expected) unless RSpec::Matchers.is_a_matcher?(expected)
        super(expected)
      end
    end
  end
end
