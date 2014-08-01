require 'rspec/change_to_now/version'
require 'rspec/core'
require 'rspec/expectations'

module RSpec::Matchers
  class BuiltIn::Change
    # @api public
    # Specifies the changed conditions
    def to_now(matcher)
      RSpec::Matchers::ChangeToNow.new(@change_details, matcher)
    end

    # @api public
    # Specifies the changed conditions
    def not_to_now(matcher)
      RSpec::Matchers::ChangeToNow.new(@change_details, matcher, true)
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
  end

  class ChangeToNow
    include Composable

    def initialize(change_details, matcher, negate = false)
      @change_details = change_details
      @matcher = matcher
      @negate = negate
    end

    # @private
    def matches?(event_proc)
      @event_proc = event_proc
      return false unless Proc === event_proc
      return false unless @matcher.respond_to?(:matches?)
      @change_details.perform_change(event_proc)
      @change_details.changed? && matches_before? && matches_after?
    end

    # @private
    def description
      "change #{@change_details.message} to #{change_description}"
    end

    # @private
    def failure_message
      return not_passed_a_matcher_failure unless @matcher.respond_to?(:matches?)
      return not_given_a_block_failure    unless Proc === @event_proc
      return before_value_failure         unless matches_before?
      return did_not_change_failure       unless @change_details.changed?
      after_value_failure
    end

    # @private
    def change_description
      "#{'not ' if @negate}#{description_of @matcher}"
    end

    # @private
    def supports_block_expectations?
      true
    end

    private

    def matches_before?
      return @matches_before if defined? @matches_before
      @matches_before = !@matcher.matches?(@change_details.actual_before) ^ @negate
    end

    def matches_after?
      return @matches_after if defined? @matches_after
      @matches_after = @matcher.matches?(@change_details.actual_after) ^ @negate
    end

    def before_value_failure
      message_method = @negate ? :failure_message : :failure_message_when_negated
      "Before the change:\n#{@matcher.send(message_method)}"
    end

    def after_value_failure
      message_method = @negate ? :failure_message_when_negated : :failure_message
      "After the change:\n#{@matcher.send(message_method)}"
    end

    def did_not_change_failure
      "expected #{@change_details.message} to have changed to #{change_description}, but did not change"
    end

    def not_given_a_block_failure
      "expected #{@change_details.message} to have changed to #{change_description}, but was not given a block"
    end

    def not_passed_a_matcher_failure
      "expected argument to be a matcher but got: #{@matcher.inspect}"
    end
  end
end
