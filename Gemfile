source "https://rubygems.org"

gemspec

%w[rspec rspec-core rspec-expectations rspec-mocks rspec-collection_matchers rspec-support].each do |lib|
  library_path = File.expand_path("../../#{lib}", __FILE__)
  if File.exist?(library_path) && !ENV['USE_GIT_REPOS']
    gem lib, :path => library_path
  else
    gem lib, :git => "git://github.com/rspec/#{lib}.git"
  end
end

gem 'rspec-rails', :git => "git://github.com/thomas-holmes/rspec-rails", :branch => "remove-mocks"

gem 'sqlite3'

### deps for rdoc.info
group :documentation do
  gem 'yard',          '0.8.7.3', :require => false
  gem 'redcarpet',     '2.3.0'
  gem 'github-markup', '1.0.0'
end

version_file = File.expand_path("../.rails-version", __FILE__)
case version = ENV['RAILS_VERSION'] || (File.exist?(version_file) && File.read(version_file).chomp)
when /master/
  gem "rails", :git => "git://github.com/alindeman/rails.git", :branch => "issue_13390"
  gem "arel", :git => "git://github.com/rails/arel.git"
  gem "journey", :git => "git://github.com/rails/journey.git"
  gem "activerecord-deprecated_finders", :git => "git://github.com/rails/activerecord-deprecated_finders.git"
  gem "rails-observers", :git => "git://github.com/rails/rails-observers"
  gem 'sass-rails', :git => "git://github.com/rails/sass-rails.git"
  gem 'coffee-rails', :git => "git://github.com/rails/coffee-rails.git"
when /stable$/
  gem "rails", :git => "git://github.com/rails/rails.git", :branch => version
when nil, false, ""
  gem "rails", "4.0.2"
else
  gem "rails", version
end
