# frozen_string_literal: true
$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'rspec/active_model/mocks/version'

Gem::Specification.new do |s|
  s.name        = "rspec-activemodel-mocks"
  s.version     = RSpec::ActiveModel::Mocks::Version::STRING
  s.platform    = Gem::Platform::RUBY
  s.license     = "MIT"
  s.authors     = ["David Chelimsky", "Andy Lindeman", "Thomas Holmes"]
  s.email       = "rspec@googlegroups.com"
  s.homepage    = "https://github.com/rspec/rspec-activemodel-mocks"
  s.summary     = "rspec-activemodel-mocks-#{RSpec::ActiveModel::Mocks::Version::STRING}"
  s.description = "RSpec test doubles for ActiveModel and ActiveRecord"

  s.metadata = {
    'bug_tracker_uri' => 'https://github.com/rspec/rspec-activemodel-mocks/issues',
    'documentation_uri' => 'https://rspec.info/documentation/',
    'mailing_list_uri' => 'https://groups.google.com/forum/#!forum/rspec',
    'source_code_uri' => 'https://github.com/rspec/rspec-activemodel-mocks',
    'rubygems_mfa_required' => 'true'
  }

  s.files             = `git ls-files -- lib/*`.split("\n")
  s.files            += %w[README.md License.txt .yardopts]
  s.test_files        = `git ls-files -- {spec,features}/*`.split("\n")
  s.rdoc_options      = ["--charset=UTF-8"]
  s.require_path      = "lib"

  private_key = File.expand_path('~/.gem/rspec-gem-private_key.pem')
  if File.exist?(private_key)
    s.signing_key = private_key
    s.cert_chain = [File.expand_path('~/.gem/rspec-gem-public_cert.pem')]
  end

  s.add_dependency('activemodel',   [">= 3.0"])
  s.add_dependency('activesupport', [">= 3.0"])
  s.add_dependency('rspec-mocks',   [">= 2.99", "< 4.0"])
end
