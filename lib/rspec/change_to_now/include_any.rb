require 'rspec/core'
require 'rspec/expectations'

module RSpec
  module Matchers
    # @api private
    # Provides the implementation for `include`.
    # Not intended to be instantiated directly.
    class IncludeAny < BuiltIn::Include
      def initialize(*expected, &block)
        @expected = expected
        @block = block
      end

      # @api private
      # @return [Boolean]
      def matches?(actual)
        @actual = actual
        perform_match(:all?, :all?)
      end

      # @api private
      # @return [Boolean]
      def does_not_match?(actual)
        @actual = actual
        perform_match(:none?, :any?)
      end

      def perform_match(predicate, hash_subset_predicate)
        if @block
          block_matcher = RSpec::Matchers::BuiltIn::Satisfy.new(&@block)
          if @actual.is_a?(Hash)
            @actual = @actual.to_a
            @restore_hash = true
          end
          @expected << block_matcher
        end
        return false if has_both_block_and_arguments?
        super
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
        "include can take arguments or a block but not both"
      end

      def has_both_block_and_arguments?
        @block && @expected.length > 1
      end

      def check_arguments
        return block_and_arguments_together_failure_message if has_both_block_and_arguments?
        @actual = @actual.to_h if @restore_hash
        nil
      end
    end

    def include(*args, &block)
      IncludeAny.new(*args, &block)
    end

    alias_matcher :include_any, :include
  end
end
