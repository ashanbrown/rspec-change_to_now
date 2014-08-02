Feature: detect matcher

  Scenario: when the matcher matches
    Given a file named "example_spec.rb" with:
    """ruby

        describe "detecting even numbers" do
          it "detects even" do
            expect([2]).to detect(&:even?)
          end
        end
      """
    When I run rspec
    Then the examples should all pass

  Scenario: failures are correctly reported
    Given a file named "example_spec.rb" with:
    """ruby

        describe "detecting even numbers" do
          it "fails for odd numbers" do
            expect([1]).to detect(&:even?)
          end
        end
      """
    When I run rspec
    Then the output should contain "Failure/Error: expect([1]).to detect(&:even?)"
      And the output should contain "expected [1] to detect (satisfy block)"
