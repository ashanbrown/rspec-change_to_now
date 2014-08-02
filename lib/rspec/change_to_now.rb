require 'rspec/change_to_now/version'
require 'rspec/change_to_now/detect'
require 'rspec/change_to_now/negate'
require 'rspec/core'
require 'rspec/expectations'

module RSpec::Matchers
  class BuiltIn::Change
    # @api public
    # Specifies the changed conditions
    def to_now(matcher)
      RSpec::Matchers::BuiltIn::ChangeToValue.new(@change_details, matcher).from(negate(matcher))
    end

    # @api public
    # Specifies the changed conditions
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

    def negate(matcher)
      RSpec::Matchers::Negate.new(matcher)
    end
  end
end
