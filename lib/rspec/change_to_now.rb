require 'rspec/change_to_now/version'
require 'rspec/change_to_now/matchers'
require 'rspec/core'
require 'rspec/expectations'

module RSpec
  module Matchers::BuiltIn
    class Change
      include RSpec::ChangeToNow::Matchers::DSL

      # @api public
      # Passes if +matcher+ fails on the result of the change block before the expectation block and passes after.
      #
      # @example
      #   expect({ @x = 1 }.to change { @x }.to_now eq 1
      #
      # In implementation, this is identical to
      #   change {}.to eq { }`
      # is the same as
      #   change {}.to_now eq(1)
      #   change {}.from(negate(eq(1))).to(eq(1))
      def to_now(matcher)
        RSpec::Matchers::BuiltIn::ChangeToValue.new(@change_details, matcher_only(matcher)).
          from(negate(matcher_only(matcher)))
      end

      # @api public
      # Passes if +matcher+ passes on the result of the change block before the expectation block and fails after.
      #
      # @example
      #   expect({ @x = 1 }.to change { @x }.not_to_now eq 1
      def not_to_now(matcher)
        RSpec::Matchers::BuiltIn::ChangeToValue.new(@change_details, negate(matcher_only(matcher))).
          from(matcher_only(matcher))
      end

      # @api public
      alias_method :now_to, :to_now

      # @api public
      alias_method :not_to, :not_to_now

      # @api public
      alias_method :not_now_to, :not_to_now

      # @api public
      alias_method :to_not, :not_to_now

      # @api public
      alias_method :to_not_now, :not_to_now

      # @private
      alias_method :to_without_to_now, :to

      # @private
      def to_with_to_now(expected)
        if RSpec::ChangeToNow.override_to && RSpec::Matchers.is_a_matcher?(expected)
          to_now(expected)
        else
          to_without_to_now(expected)
        end
      end

      # @private
      alias_method :to, :to_with_to_now

      # @api public
      def with_final_result(expected)
        to_without_to_now(expected)
      end
    end

    class ChangeFromValue
      include RSpec::ChangeToNow::Matchers::DSL

      def to_now(matcher)
        RSpec::Matchers::BuiltIn::ChangeToValue.new(
          @change_details,
          matcher_only(matcher)
        ).from(@expected_before)
      end

      def not_to_now(matcher)
        RSpec::Matchers::BuiltIn::ChangeToValue.new(
          @change_details,
          negate(matcher_only(matcher))
        ).from(@expected_before)
      end

      def with_final_result(expected)
        to_without_to_now(expected)
      end
    end
  end

  module ChangeToNow
    class << self
      attr_accessor :override_to
    end
  end
end

RSpec.configure { |c| c.include RSpec::ChangeToNow::Matchers::DSL::Detect } if RSpec.respond_to?(:configure)
