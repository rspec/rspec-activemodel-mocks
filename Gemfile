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

gem 'sqlite3'

### deps for rdoc.info
group :documentation do
  gem 'yard',          '0.8.7.3', :require => false
  gem 'redcarpet',     '2.3.0'
  gem 'github-markup', '1.0.0'
end

case version = ENV['RAILS_VERSION']
when /master/
  gem "activerecord", :git => "git://github.com/rails/activerecord.git"
  gem "activerecord-deprecated_finders", :git => "git://github.com/rails/activerecord-deprecated_finders.git"
  gem "activesupport", :git => "git://github.com/rails/activesupport.git"
when nil, false, ""
  gem "activerecord", "4.0.2"
  gem "activesupport", "4.0.2"
  #gem "activerecord-deprecated_finders"
else
  gem "activerecord", version
  gem "activesupport", version
  #gem "activerecord-deprecated_finders"
end
