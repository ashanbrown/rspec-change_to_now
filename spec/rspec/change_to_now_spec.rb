require 'spec_helper'

module RSpec
  describe Matchers::BuiltIn::Change do
    describe "#to_now" do
      it "succeeds when the condition changes to the expected state" do
        number = 1
        expect {
          number += 1
        }.to change { number }.to_now eq 2
      end
      it "fails when there is no change" do
        number = 1
        expect {
          expect {
          }.to change { number }.to_now eq 2
        }.to fail_matching("did not change")
      end
      it "fails without an expectation block" do
        expect {
          expect(1).to change { number }.to_now eq 2
        }.to fail_matching("was not given a block")
      end
      it "fails when the argument is not a matcher" do
        expect {
          expect { }.to change { number }.to_now 2
        }.to fail_matching("to be a matcher but got")
      end
      it "fails when the final expectation is never met" do
        number = 1
        expect {
          expect {
            number += 1
          }.to change { number }.to_now eq 3
        }.to fail_matching(/After the change.*got: 2/m)
      end
      it "fails when the final expectation is already met" do
        number = 2
        expect {
          expect {
            number += 1
          }.to change { number }.to_now eq 2
        }.to fail_matching(/Before the change.*got: 2/m)
      end
    end

    describe "#not_to" do
      it "succeeds when the final expectation is met" do
        number = 1
        expect {
          number += 2
        }.to change { number }.not_to eq 1
      end
      it "fails when there is no change" do
        number = 1
        expect {
          expect {
          }.to change { number }.not_to eq 1
        }.to fail_matching("did not change")
      end
      it "fails when the final expectation is already met" do
        number = 2
        expect {
          expect {
          }.to change { number }.not_to eq 1
        }.to fail_matching(/Before the change.*got: 2/m)
      end
      it "fails when the final expectation is never met" do
        number = 2
        expect {
          expect {
            number = 4
          }.to change { number }.not_to satisfy(&:even?)
        }.to fail_matching(/After the change.*not to satisfy/m)
      end
    end

    describe "aliases" do
      before do
        @x = nil
      end

      it "specify #now_to is the same as #to_now" do
        expect { @x = 1 }.to change { @x }.now_to eq 1
      end

      describe "negative cases" do
        specify "#to_not is the same as #not_to" do
          expect { @x = 1 }.to change { @x }.to_not eq nil
        end

        specify "#to_not_now is the same as #not_to_now" do
          expect { @x = 1 }.to change { @x }.to_not_now eq nil
        end

        specify "#not_now to_is the same as #not_to_now" do
          expect { @x = 1 }.to change { @x }.not_now_to eq nil
        end

        specify "#to_not_now to_is the same as #not_to_now" do
          expect { @x = 1 }.to change { @x }.to_not_now eq nil
        end
      end
    end
  end
end
