require_relative '../spec_helper'

RSpec.describe RSpec::Matchers::Negate do
  describe "with literal expectations" do
    it "passes if the original matcher fails" do
      expect(1).to negate(eq(2))
    end
    it "fails if the original matcher passes" do
      expect {
        expect(1).to negate(eq(1))
      }.to fail_matching(/expected: value != 1.*got: 1/m)
    end
  end

  describe "with block expectations" do
    before do
      @x = 1
    end

    it "fails for `change` because it doesn't support negation" do
      expect {
        expect {@x += 1}.to negate(change { @x }.to(1))
      }.to raise_error(NotImplementedError,
                       "`expect { }.not_to change { }.to()` is not supported")
    end
  end
end
