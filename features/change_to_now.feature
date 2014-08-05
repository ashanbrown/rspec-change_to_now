Feature: expecting a matcher to change

  Scenario: when the matcher matches only after the block
    Given a file named "example_spec.rb" with:
      """ruby

        describe "adding one" do
          it "adds one" do
            x = 1
            expect { x += 1 }.to change { x }.to_now eq 2
          end
        end
      """
    When I run rspec
    Then the examples should all pass

  Scenario: the result of a change block can be tested with `with_final_result` without invoking the precondition test
    Given a file named "example_spec.rb" with:
      """ruby

        describe "creating a list" do
          it "creates an empty list" do
            list = nil
            expect { list = [] }.to change { list }.with_final_result satisfy(&:empty?)
          end
        end
      """
    When I run rspec
    Then the examples should all pass

 Scenario: precondition failures are correctly reported
    Given a file named "example_spec.rb" with:
      """ruby

        describe "adding one" do
          it "adds one" do
            x = 2
            expect { x += 1 }.to change { x }.to_now eq 2
          end
        end
      """
    When I run rspec
    Then the output should contain "Failure/Error: expect { x += 1 }.to change { x }.to_now eq 2"
    And the output should contain "expected result to have initially been ~(eq 2), but was 2"

  Scenario: overriding RSpec `change { }.to` to behave like `change { }.to_now`
    Given a file named "example_spec.rb" with:
      """ruby
        RSpec::ChangeToNow.override_to = true

        describe "adding one" do
          it "adds one" do
            x = 2
            expect { x += 1 }.to change { x }.to eq 2
          end
        end
      """
    When I run rspec
    Then the output should contain "Failure/Error: expect { x += 1 }.to change { x }.to eq 2"
    And the output should contain "expected result to have initially been ~(eq 2), but was 2"
