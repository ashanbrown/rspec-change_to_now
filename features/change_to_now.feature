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

 Scenario: failures are correctly reported
    Given a file named "example_spec.rb" with:
      """ruby

        describe "adding one" do
          it "adds one" do
            x = 1
            expect { x += 1 }.to change { x }.to_now eq 3
          end
        end
      """
    When I run rspec
    Then the output should contain "Failure/Error: expect { x += 1 }.to change { x }.to_now eq 3"
