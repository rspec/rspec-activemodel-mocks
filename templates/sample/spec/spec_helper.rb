$:<< File.join(File.dirname(__FILE__), '..')
require 'active_record'
require 'yaml'
require 'rspec/active_model/mocks'

require 'models/widget'

db_config = YAML::load(File.open('db/config.yml'))

ActiveRecord::Base.establish_connection(db_config['test'])

RSpec.configure do |config|
  config.around(:each) do |ex|
    x = proc do
      ex.call
      raise ActiveRecord::Rollback
    end
    ActiveRecord::Base.transaction(&x)
  end

  config.order = 'random'
end
