require 'rspec/core'
require 'rspec/expectations'

module RSpec
  module Matchers
    # @api private
    # Provides the implementation for `detect`.
    # Not intended to be instantiated directly.
    class Detect < BuiltIn::Include
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
        return false if has_both_block_and_arguments?
        original_actual = actual
        actual = actual.to_a if @block && actual.is_a?(Hash)
        value = yield(actual)
        @actual = original_actual
        value
      end
    end

    # If given a block, passes if the block returns a truthy value for any of the actual items or for the key-value pair is the actual item list is a hash.
    # Without a block, it behaves identically to +include+.
    # +expected+ must be empty if a block is provided.
    #
    # @example
    #   expect([2]).to detect(&:even?)
    #   expect({a: 2}).to detect { |k,v| v.even? }
    #   expect([1]).to detect 1
    def detect(*expected, &block)
      AliasedMatcher.new(Detect.new(*expected, &block), lambda do |old_desc|
        old_desc.gsub(Pretty.split_words('include'), Pretty.split_words('detect'))
      end)
    end
  end
end
