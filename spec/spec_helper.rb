# frozen_string_literal: true
require 'logger'
require 'rspec/active_model/mocks'
require 'active_record'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].sort.each {|f| require f}

module RSpec
  module Core
    class ExampleGroup
      def self.run_all(reporter=nil)
        run(reporter || RSpec::Mocks::Mock.new('reporter').as_null_object)
      end
    end
  end
end

RSpec.configure do |config|
  real_world = nil

  config.filter_run :focus
  config.run_all_when_everything_filtered = true
  config.before(:each) do
    real_world = RSpec.world
    RSpec.instance_variable_set(:@world, RSpec::Core::World.new)
  end
  config.after(:each) do
    RSpec.instance_variable_set(:@world, real_world)
  end

  config.order = :random
end
