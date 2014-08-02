require_relative '../spec_helper'

RSpec.describe "#include matcher" do
  describe "expect(...).to include(&with_block)" do
    context "for an array target" do
      it "passes if target includes expected" do
        expect([1,2,3]).to include(&:even?)
      end

      it "fails if target does not include expected" do
        expect {
          expect([1,3]).to include(&:even?)
        }.to fail_matching("expected [1, 3] to include (satisfy block)")
      end
    end

    context "for a hash target" do
      it 'passes if target has the expected as a key' do
        expect({:key => 0}).to include { |key,value| value.even? }
      end

      it "fails if target does not include expected" do
        expect {
          expect({:key => 1}).to include { |key,value| value.even? }
        }.to fail_matching("expected {:key => 1} to include (satisfy block)")
      end
    end
  end

  describe "expect(...).not_to include(&with_block)" do
    context "for an array target" do
      it "passes if target includes expected" do
        expect([1,3]).not_to include(&:even?)
      end

      it "fails if target does not include expected" do
        expect {
          expect([1,3]).not_to include(&:odd?)
        }.to fail_matching("expected [1, 3] not to include (satisfy block)")
      end
    end

    context "for a hash target" do
      it 'passes if target has the expected as a key' do
        expect({:key => 0}).not_to include { |key,value| value.odd? }
      end

      it "fails if target does not include expected" do
        expect {
          expect({:key => 1}).not_to include { |key,value| value.odd? }
        }.to fail_matching("expected {:key => 1} not to include (satisfy block)")
      end
    end
  end

  describe "expect(...).to include(with, args, and, &block)" do
    it "fails with a message" do
      expect {
        expect([0, 1]).to include(0) { true }
      }.to fail_matching(%Q{can take arguments or a block but not both})
    end
  end

  describe "expect(...).not_to include(with, args, and, &block)" do
    it "fails with a message" do
      expect {
        expect([0, 1]).not_to include(0) { true }
      }.to fail_matching(%Q{can take arguments or a block but not both})
    end
  end
end
