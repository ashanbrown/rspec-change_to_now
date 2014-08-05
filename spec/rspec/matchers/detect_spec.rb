require_relative 'spec_helper'

describe "detect" do
  describe "expect(...).to detect(&with_block)" do
    context "for an array target" do
      it "passes if target detects expected" do
        expect([1,2,3]).to detect(&:even?)
      end

      it "fails if target does not detect expected" do
        expect {
          expect([1,3]).to detect(&:even?)
        }.to fail_matching("expected [1, 3] to detect (satisfy block)")
      end
    end

    context "for a hash target" do
      it 'passes if target has the expected as a key' do
        expect({:key => 0}).to detect { |key,value| value.even? }
      end

      it "fails if target does not detect expected" do
        expect {
          expect({:key => 1}).to detect { |key,value| value.even? }
        }.to fail_matching("expected {:key => 1} to detect (satisfy block)")
      end
    end
  end

  describe "expect(...).not_to detect(&with_block)" do
    context "for an array target" do
      it "passes if target detects expected" do
        expect([1,3]).not_to detect(&:even?)
      end

      it "fails if target does not detect expected" do
        expect {
          expect([1,3]).not_to detect(&:odd?)
        }.to fail_matching("expected [1, 3] not to detect (satisfy block)")
      end
    end

    context "for a hash target" do
      it 'passes if target has the expected as a key' do
        expect({:key => 0}).not_to detect { |key,value| value.odd? }
      end

      it "fails if target does not detect expected" do
        expect {
          expect({:key => 1}).not_to detect { |key,value| value.odd? }
        }.to fail_matching("expected {:key => 1} not to detect (satisfy block)")
      end
    end
  end

  describe "expect(...).to detect(with, args, and, &block)" do
    it "fails with a message" do
      expect {
        expect([0, 1]).to detect(0) { true }
      }.to raise_error SyntaxError, "detect can take arguments or a block but not both"
    end
  end

  describe "expect(...).not_to detect(with, args, and, &block)" do
    it "fails with a message" do
      expect {
        expect([0, 1]).not_to detect(0) { true }
      }.to raise_error SyntaxError, "detect can take arguments or a block but not both"
    end
  end
end
