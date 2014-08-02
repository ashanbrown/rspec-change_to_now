require_relative '../spec_helper'

RSpec.describe RSpec::Matchers::Negate do
  describe "with literal expectations" do
    describe "when not negated" do
      describe "when the original matcher provides :does_not_match?" do
        it "passes if the original matcher fails" do
          expect(1).to negate(eq(2))
        end
        it "fails if the original matcher passes" do
          expect {
            expect(1).to negate(eq(1))
          }.to fail_matching(/expected: value != 1.*got: 1/m)
        end
      end
      describe "when the original matcher does not provide :does_not_match?" do
        it "generates the correct message if the original matcher passes" do
          duck_matcher = double(
            'matches?' => true,
            description: 'be a duck',
            actual: 'my duck',
            failure_message: 'need this to convince the code that this is a matcher'
          )
          expect {
            expect('my duck').to negate(duck_matcher)
          }.to fail_matching(%Q|expected "my duck" not to (be a duck)|)
        end
      end
    end

    describe "when negated" do
      it "passes if the original matcher passes" do
        expect(1).not_to negate(eq(1))
      end
      it "fails unless the original matcher passes " do
        expect {
          expect(2).not_to negate(eq(1))
        }.to fail_matching(/expected: 1.*got: 2/m)
      end
    end

    it "returns a negated description" do
      expect(negate(eq(1)).description).to eq "~(eq 1)"
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
