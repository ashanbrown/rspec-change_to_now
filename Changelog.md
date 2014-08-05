### 1.2.0

* Make it easy to include `negate` and `matcher_only` matchers.
* Move `RSpec::Matchers::ChangeToNow.override_to` setting to `RSpec::ChangeToNow.override_to`
* When passed both arguments and a block, `detect` will raise a `SyntaxError` instead of `ExpectationNotMet`
* When passed an object that is not a matcher, `to_now` will behave like `to`, albeit reporting precondition failures.

### 1.1.0

* Add `with_final_result` matcher that doesn't do precondition test
* Correctly support `to_now` alongside `from` 

### 1.0.3

Refer to 'detect' instead of 'include' in messages for detect matcher. 

### 1.0.2

Fix description and failure messages when failure_message_when_negated does not exist on target of negate matcher

### 1.0.1

Fix gem dependencies

### 1.0.0

Initial Version

