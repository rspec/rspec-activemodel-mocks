# frozen_string_literal: true
Then /^the example(s)? should( all)? pass$/ do |_, _|
  step 'the output should contain "0 failures"'
  step 'the exit status should be 0'
end
