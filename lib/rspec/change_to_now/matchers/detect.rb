require 'rspec/core'
require 'rspec/expectations'

module RSpec::ChangeToNow
  module Matchers
    # @api private
    # Provides the implementation for `detect`.
    # Not intended to be instantiated directly.
    class Detect < RSpec::Matchers::BuiltIn::Include
      def initialize(*expected, &block)
        if @block = block
          block_matcher = RSpec::Matchers::BuiltIn::Satisfy.new(&block)
          expected << block_matcher
        end
        super(*expected)
      end

      # @api private
      # @return [Boolean]
      def matches?(actual)
        handle_arguments_for_match(actual) do |new_actual|
          super(new_actual)
        end
      end

      # @api private
      # @return [Boolean]
      def does_not_match?(actual)
        handle_arguments_for_match(actual) do |new_actual|
          super(new_actual)
        end
      end

      # @api private
      # @return [String]
      def failure_message
        check_arguments || super
      end

      # @api private
      # @return [String]
      def failure_message_when_negated
        check_arguments || super
      end

      # @api private
      # @return [Boolean]
      def diffable?
        @block.nil?
      end

      # @api private
      # @return [String]
      def description
        super.gsub(/^include/, 'detect')
      end

      private

      def block_and_arguments_together_failure_message
        "detect can take arguments or a block but not both"
      end

      def has_both_block_and_arguments?
        @block && @expected.length > 1
      end

      def check_arguments
        block_and_arguments_together_failure_message if has_both_block_and_arguments?
      end

      def handle_arguments_for_match(actual)
        raise SyntaxError, block_and_arguments_together_failure_message if has_both_block_and_arguments?
        original_actual = actual
        actual = actual.to_a if @block && actual.is_a?(Hash)
        value = yield(actual)
        @actual = original_actual
        value
      end
    end
  end
end
