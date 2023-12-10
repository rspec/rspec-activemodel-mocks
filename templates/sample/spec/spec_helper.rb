# frozen_string_literal: true
$:<< File.join(File.dirname(__FILE__), '..')
require 'active_record'
require 'rspec/active_model/mocks'
require 'model/widget'

ActiveRecord::Base.establish_connection :adapter => "sqlite3", :database => ":memory:"

load 'db/schema.rb'

RSpec.configure do |config|
  config.order = 'random'
end
