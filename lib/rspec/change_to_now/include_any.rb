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
      def matches?(actual, &block)
        @actual = actual
        @block ||= block
        if @block
          perform_match_for_block
        else
          perform_match(:all?, :all?)
        end
      end

      # @api private
      # @return [Boolean]
      def does_not_match?(actual, &block)
        @actual = actual
        @block ||= block
        if @block
          perform_match_for_block(true)
        else
          perform_match(:none?, :any?)
        end
      end

      # @api private
      # @return [String]
      def description
        if @block
          "include block"
        else
          super
        end
      end

      # @api private
      # @return [String]
      def failure_message
        if @block
          return block_and_arguments_together_failure_message unless @expected.empty?
          described_items = surface_descriptions_in(@actual)
          improve_hash_formatting "expected one of#{to_sentence(described_items)} to satisfy block"
        else
          super
        end
      end

      # @api private
      # @return [String]
      def failure_message_when_negated
        @block && !@expected.nil?
        if @block
          return block_and_arguments_together_failure_message unless @expected.empty?
          described_items = surface_descriptions_in(@actual)
          improve_hash_formatting "expected none of#{to_sentence(described_items)} to satisfy block"
        else
          super
        end
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

      def invalid_type_message
        if @block
          return '' unless respond_to?(:detect)
          ", but it does not respond to `detect`"
        else
          super
        end
      end

      def perform_match_for_block(negate = false)
        return false if !@expected.empty?
        @actual.respond_to?(:detect) && (!@actual.detect(&@block).nil? ^ negate)
      end
    end

    def include(*args, &block)
      IncludeAny.new(*args, &block)
    end

    alias_matcher :include_any, :include
  end
end
