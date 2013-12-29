require 'rspec/core'

RSpec::configure do |c|
  c.backtrace_exclusion_patterns << /lib\/rspec\/rails\/model_mocks/
end

require 'rspec/rails/model_mocks/version'
require 'rspec/rails/model_mocks/mocks'
