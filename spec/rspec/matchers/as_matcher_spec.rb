require_relative 'spec_helper'

describe "as_matcher" do
  describe "when the argument is a matcher" do
    it "delegates to the matcher" do
      expect {
        expect(1).to as_matcher(eq 2)
      }.to fail_matching(/expected: 2.*got: 1/m)
    end
  end

  describe "when the argument is not a matcher" do
    it "uses the default matcher" do
      expect {
        expect(1).to as_matcher(2)
      }.to fail_matching(/expected 1 to match 2/m)
    end
  end
end
