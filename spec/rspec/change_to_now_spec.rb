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
        }.to fail_matching("expected result to have changed to eq 2 from ~(eq 2), but did not change")
      end
      it "fails without an expectation block" do
        expect {
          expect(1).to change { }.to_now eq 2
        }.to fail_matching("was not given a block")
      end
      it "fails when the final expectation is never met" do
        number = 1
        expect {
          expect {
            number += 1
          }.to change { number }.to_now eq 3
        }.to fail_matching("expected result to have changed to eq 3, but is now 2")
      end
      it "fails when the final expectation is already met" do
        number = 2
        expect {
          expect {
            number += 1
          }.to change { number }.to_now eq 2
        }.to fail_matching("expected result to have initially been ~(eq 2), but was 2")
      end
      it "raises an error when not passed a matcher" do
        number = 1
        expect {
          expect {
            number += 1
          }.to change { }.to_now 2
        }.to raise_error SyntaxError, /expected a matcher as an argument/
      end

      describe "after #from" do
        it "passes without running the default inverse precondition check" do
          list = nil
          expect {
            list = []
          }.to change { list }.from(nil).to_now satisfy(&:empty?)
        end

        it "fails if the initial condition does not match" do
          expect {
            list = nil
            expect {
              list = []
            }.to change { list }.from(1).to_now satisfy(&:empty?)
          }.to fail_matching("expected result to have initially been 1, but was nil")
        end
      end

      describe "before #from" do
        it "passes without running the default inverse precondition check" do
          list = nil
          expect {
            list = []
          }.to change { list }.to_now(satisfy(&:empty?)).from(nil)
        end

        it "fails if the initial condition does not match" do
          expect {
            list = nil
            expect {
              list = []
            }.to change { list }.to_now(satisfy(&:empty?)).from(1)
          }.to fail_matching("expected result to have initially been 1, but was nil")
        end
      end
    end

    describe "#not_to_now" do
      it "succeeds when the final expectation is met" do
        number = 1
        expect {
          number += 2
        }.to change { number }.not_to_now eq 1
      end
      it "fails when there is no change" do
        number = 1
        expect {
          expect {
          }.to change { number }.not_to_now eq 1
        }.to fail_matching("expected result to have changed to ~(eq 1) from eq 1, but did not change")
      end
      it "fails when the final expectation is already met" do
        number = 2
        expect {
          expect {
          }.to change { number }.not_to_now eq 1
        }.to fail_matching("expected result to have initially been eq 1, but was 2")
      end
      it "fails when the final expectation is never met" do
        number = 2
        expect {
          expect {
            number = 4
          }.to change { number }.not_to_now satisfy(&:even?)
        }.to fail_matching("expected result to have changed to ~(satisfy block), but is now 4")
      end
      it "raises an error when not passed a matcher" do
        number = 1
        expect {
          expect {
            number += 1
          }.to change { }.not_to_now 2
        }.to raise_error SyntaxError, /expected a matcher as an argument/
      end

      describe "after #from" do
        it "passes without running the default inverse precondition check" do
          list = nil
          expect {
            list = [1]
          }.to change { list }.from(nil).not_to_now satisfy(&:empty?)
        end

        it "fails if the initial condition does not match" do
          expect {
            list = nil
            expect {
              list = [1]
            }.to change { list }.from(1).not_to_now satisfy(&:empty?)
          }.to fail_matching("expected result to have initially been 1, but was nil")
        end
      end

      describe "before #from" do
        it "passes without running the default inverse precondition check" do
          list = nil
          expect {
            list = [1]
          }.to change { list }.not_to_now(satisfy(&:empty?)).from(nil)
        end

        it "fails if the initial condition does not match" do
          expect {
            list = nil
            expect {
              list = [1]
            }.to change { list }.not_to_now(satisfy(&:empty?)).from(1)
          }.to fail_matching("expected result to have initially been 1, but was nil")
        end
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
        specify "#to_not is the same as #not_to_now" do
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

    describe "#with_final_result" do
      before do
        @x = nil
      end

      it "checks only the post condition not the precondition" do
        expect { @x = [] }.to change { @x }.with_final_result satisfy(&:empty?)
      end
      describe "when passed an object" do
        it "passes when the final object equals the result" do
          expect { @x = 1 }.to change { @x }.with_final_result 1
        end
        it "fails when the final object does not equal the result" do
          expect {
            expect { @x = 1 }.to change { @x }.with_final_result 2
          }.to fail_matching("expected result to have changed to 2, but is now 1")
        end
      end

      it "behaves exactly like the original #to method" do
        matcher = change { @x }
        matcher_mock = double()
        expect(matcher).to receive(:to_without_to_now).with(1).and_return(matcher_mock)
        expect(matcher.with_final_result 1).to eq matcher_mock
      end
        
      describe "after #from" do
        it "behaves exactly like the original #to method" do
          matcher = change { @x }.from 0
          matcher_mock = double()
          expect(matcher).to receive(:to_without_to_now).with(1).and_return(matcher_mock)
          expect(matcher.with_final_result 1).to eq matcher_mock
        end
      end
    end

    describe "when #to has been overridden by the configuration setting" do
      before do
        allow(RSpec::ChangeToNow).to receive(:override_to).and_return(true)
      end

      it "fails when the final expectation is already met" do
        number = 2
        expect {
          expect {
            number += 1
          }.to change { number }.to eq 2
        }.to fail_matching("expected result to have initially been ~(eq 2), but was 2")
      end

      it "still works with basic object matchers" do
        number = 2
        expect {
          expect {
            number += 1
          }.to change { number }.to 2
        }.to fail_matching("expected result to have changed to 2, but is now 3")
      end

      describe "if #from is specified first" do
        let(:matcher) { change { @number }.from(1).to(eq 2) }

        it "fails properly when the precondition is not met" do
          @number = 2
          expect {
            expect {
              @number += 1
            }.to matcher
          }.to fail_matching("expected result to have initially been 1, but was 2")
        end

        it "runs the change check if the precondition is met" do
          @number = 1
          expect {
            expect {
              @number += 2
            }.to matcher
          }.to fail_matching("expected result to have changed to eq 2, but is now 3")
        end
      end

      describe "if #from is specified after #to" do
        let(:matcher) { change { @number }.to(eq 2).from(1) }

        it "fails properly when the precondition is not met" do
          @number = 2
          expect {
            expect {
              @number += 1
            }.to matcher
          }.to fail_matching("expected result to have initially been 1, but was 2")
        end

        it "runs the change check if the precondition is met" do
          @number = 1
          expect {
            expect {
              @number += 2
            }.to matcher
          }.to fail_matching("expected result to have changed to eq 2, but is now 3")
        end
      end
    end
  end
end
