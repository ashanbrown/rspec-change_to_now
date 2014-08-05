require 'rspec/core'
require 'rspec/expectations'

module RSpec
  module ChangeToNow::Matchers
    # @api private
    # Provides the implementation for `negate`.
    # Not intended to be instantiated directly.
    class Negate
      include RSpec::Matchers::Composable
      include RSpec::Matchers::Pretty

      def initialize(matcher)
        @matcher = matcher
      end

      # @api private
      # @return [Boolean]
      def matches?(*args, &block)
        if @matcher.respond_to?(:does_not_match?)
          @matcher.does_not_match?(*args, &block)
        else
          !@matcher.matches?(*args, &block)
        end
      end

      # @api private
      # @return [Boolean]
      def does_not_match?(*args, &block)
        @matcher.matches?(*args, &block)
      end

      # @private
      # @return [String]
      def failure_message
        if @matcher.respond_to? :failure_message_when_negated
          @matcher.failure_message_when_negated
        elsif @matcher.respond_to? :description
          "expected #{surface_descriptions_in(@matcher.actual).inspect} not to #{surface_descriptions_in(@matcher).inspect}"
        end
      end

      # @api private
      # @return [String]
      def failure_message_when_negated
        @matcher.failure_message
      end

      # @api private
      # @return [String]
      def description
        "~#{surface_descriptions_in(@matcher).inspect}"
      end

      # @api private
      # @return [Boolean]
      def supports_block_expectations?
        @matcher.supports_block_expectations?
      end
    end
  end
end
