require 'rspec/change_to_now/version'
require 'rspec/change_to_now/detect'
require 'rspec/change_to_now/negate'
require 'rspec/core'
require 'rspec/expectations'

module RSpec::Matchers
  class BuiltIn::Change
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
      RSpec::Matchers::BuiltIn::ChangeToValue.new(@change_details, matcher).from(negate(matcher))
    end

    # @api public
    # Passes if +matcher+ passes on the result of the change block before the expectation block and fails after.
    #
    # @example
    #   expect({ @x = 1 }.to change { @x }.not_to_now eq 1
    def not_to_now(matcher)
      RSpec::Matchers::BuiltIn::ChangeToValue.new(@change_details, negate(matcher)).from(matcher)
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

    private

    # @private
    def negate(matcher)
      RSpec::Matchers::Negate.new(matcher)
    end
  end
end
