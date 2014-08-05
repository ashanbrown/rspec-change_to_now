module RSpec::ChangeToNow::Matchers::DSL
  # @api public
  # Returns a new matcher that fails with a syntax error if +matcher+ is not a matcher but otherwise behaves just like +matcher+.
  def matcher_only(matcher)
    RSpec::ChangeToNow::Matchers::MatcherOnly.new(matcher)
  end

  # @api public
  # Returns a matcher that behaves like the inverse of +matcher+.
  def negate(matcher)
    RSpec::ChangeToNow::Matchers::Negate.new(matcher)
  end

  # @api public
  # Returns a matcher that behaves like the +matcher+ if passed a matcher, otherwise like match(+matcher+)
  def as_matcher(expected)
    RSpec::ChangeToNow::Matchers::AsMatcher.new(expected)
  end

  module Detect
    # @api public
    # If given a block, passes if the block returns a truthy value for any of the actual items or for the key-value pair is the actual item list is a hash.
    # Without a block, it behaves identically to +include+.
    # +expected+ must be empty if a block is provided.
    #
    # @example
    #   expect([2]).to detect(&:even?)
    #   expect({a: 2}).to detect { |k,v| v.even? }
    #   expect([1]).to detect 1
    def detect(*expected, &block)
      RSpec::ChangeToNow::Matchers::Detect.new(*expected, &block)
    end
  end

  include Detect
end
