Feature: negating a matcher

  Scenario: when the matcher is negated
    Given a file named "example_spec.rb" with:
    """ruby
        include RSpec::ChangeToNow::Matchers::DSL

        describe "testing equality" do
          it "is the same as negated inequality" do
            expect(1).to negate(eq(2))
          end
        end
      """
    When I run rspec
    Then the examples should all pass

  Scenario: failures are correctly reported
    Given a file named "example_spec.rb" with:
    """ruby
        include RSpec::ChangeToNow::Matchers::DSL

        describe "testing equality" do
          it "fails if the the negated matcher does match" do
            expect(1).to negate(eq(1))
          end
        end
      """
    When I run rspec
    Then the output should contain "Failure/Error: expect(1).to negate(eq(1))"
      And the output should contain "expected: value != 1"

