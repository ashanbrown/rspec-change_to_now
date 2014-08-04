require_relative '../spec_helper'

describe RSpec::Matchers::VerifyArgumentIsMatcher do
  describe "when the argument is a matcher" do
    it "delegates to the matcher" do
      expect {
        expect(1).to RSpec::Matchers::VerifyArgumentIsMatcher.new(eq 2)
      }.to fail_matching(/expected: 2.*got: 1/m)
    end
  end

  describe "when the argument is not a matcher" do
    it "raises a syntax error when the matcher is evaluated" do
      expect {
        expect(1).to RSpec::Matchers::VerifyArgumentIsMatcher.new(2)
      }.to raise_error SyntaxError, "expects a matcher as an argument but got: 2"
    end
  end
end
