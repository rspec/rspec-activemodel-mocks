source "https://rubygems.org"

gemspec

%w[rspec rspec-core rspec-expectations rspec-mocks rspec-support].each do |lib|
  library_path = File.expand_path("../../#{lib}", __FILE__)
  if File.exist?(library_path) && !ENV['USE_GIT_REPOS']
    gem lib, :path => library_path
  else
    gem lib, :git => "git://github.com/rspec/#{lib}.git"
  end
end

gem 'sqlite3'

### deps for rdoc.info
group :documentation do
  gem 'yard',          '0.8.7.3', :require => false
  gem 'redcarpet',     '2.3.0'
  gem 'github-markup', '1.0.0'
end

case version = ENV.fetch('RAILS_VERSION', '4.0.2')
when /\Amaster\z/, /stable\z/
  gem "activerecord", :github => "rails/rails", :branch => version
  gem "activemodel", :github => "rails/rails", :branch => version
  gem "activesupport", :github => "rails/rails", :branch => version
else
  gem "activerecord", version
  gem "activemodel", version
  gem "activesupport", version
end
