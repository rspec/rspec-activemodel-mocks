source "https://rubygems.org"

gemspec

%w[rspec rspec-core rspec-expectations rspec-mocks rspec-support].each do |lib|
  library_path = File.expand_path("../../#{lib}", __FILE__)
  if File.exist?(library_path) && !ENV['USE_GIT_REPOS']
    gem lib, :path => library_path
  else
    gem lib, :git => "https://github.com/rspec/#{lib}.git", :branch => ENV.fetch('RSPEC_BRANCH', 'main')
  end
end


### deps for rdoc.info
group :documentation do
  gem 'yard',          '~> 0.9', :require => false
  gem 'redcarpet',     '2.3.0'
  gem 'github-markup', '1.0.0'
end

version = ENV.fetch('RAILS_VERSION', '6.0.0')
version_float = version.tr('-', '.').tr('~> ', '').to_f

if version_float < 4
  gem 'sqlite3', '~> 1.3.5'
elsif version_float < 6
  gem 'sqlite3', '~> 1.3.6'
else
  gem 'sqlite3', '~> 1.4'
end

if version =~ /stable\z/
  gem "activerecord", :github => "rails/rails", :branch => version
  gem "activemodel", :github => "rails/rails", :branch => version
  gem "activesupport", :github => "rails/rails", :branch => version
else
  gem "activerecord", version
  gem "activemodel", version
  gem "activesupport", version
end

if version < '4.0.0'
  gem "test-unit", '~> 3' if (version >= '3.2.22' || version == '3-2-stable')
else
  # Version 5.12 of minitest requires Ruby 2.4
  if RUBY_VERSION < '2.4.0'
    gem 'minitest', '< 5.12.0'
  else
    gem 'minitest', '>= 5.12.0', :require => false
  end
end

if RUBY_VERSION < '2.2.0' && !!(RbConfig::CONFIG['host_os'] =~ /cygwin|mswin|mingw|bccwin|wince|emx/)
  gem 'ffi', '< 1.10'
elsif RUBY_VERSION < '2.4.0' && !!(RbConfig::CONFIG['host_os'] =~ /cygwin|mswin|mingw|bccwin|wince|emx/)
  gem 'ffi', '< 1.15'
elsif RUBY_VERSION < '2.0'
  gem 'ffi', '< 1.9.19' # ffi dropped Ruby 1.8 support in 1.9.19
elsif RUBY_VERSION < '2.3.0'
  gem 'ffi', '~> 1.12.0'
else
  gem 'ffi', '~> 1.15.0'
end

gem "i18n", '< 0.7.0' if RUBY_VERSION < '1.9.3'
