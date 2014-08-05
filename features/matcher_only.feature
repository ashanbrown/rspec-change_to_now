Feature: matcher-only matcher

  Scenario: when the argument is a matcher
    Given a file named "example_spec.rb" with:
    """ruby
        include RSpec::ChangeToNow::Matchers::DSL

        describe "when passed a matcher" do
          it "just passes the matcher through" do
            expect(2).to matcher_only(eq 2)
          end
        end
      """
    When I run rspec
    Then the examples should all pass

  Scenario: when the argument is not a matcher
    Given a file named "example_spec.rb" with:
    """ruby
        include RSpec::ChangeToNow::Matchers::DSL

        describe "when passed a non-matcher object" do
          it "reports a syntax error" do
            expect(2).to matcher_only(2)
          end
        end
      """
    When I run rspec
    Then the output should contain "SyntaxError"
    And the output should contain "expected a matcher as an argument but got: 2"
