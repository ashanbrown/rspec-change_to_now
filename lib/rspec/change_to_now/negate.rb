require 'rspec/core'
require 'rspec/expectations'

module RSpec
  module Matchers
    # @api private
    # Provides the implementation for `include`.
    # Not intended to be instantiated directly.
    class Negate
      include Composable
      include Pretty

      def initialize(matcher)
        @matcher = matcher
      end

      # @private
      def matches?(*args, &block)
        if @matcher.respond_to?(:does_not_match?)
          @matcher.does_not_match?(*args, &block)
        else
          !@matcher.matches?(*args, &block)
        end
      end

      # @private
      def does_not_match?(*args, &block)
        @matcher.matches?(*args, &block)
      end

      # @private
      def failure_message
        if @matcher.respond_to? :failure_message_when_negated
          @matcher.failure_message_when_negated
        elsif @matcher.respond_to :description
          "expected #{surface_descriptions_in @actual} not to #{surface_descriptions_in @matcher}"
        end
      end

      # @private
      def failure_message_when_negated
        failure_message
      end

      # @private
      def description
        "not #{surface_descriptions_in @matcher}"
      end

      # @private
      def supports_block_expectations?
        @matcher.supports_block_expectations?
      end
    end

    def negate(matcher)
      Negate.new(matcher)
    end
  end
end
