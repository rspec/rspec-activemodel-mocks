require "bundler"
begin
  Bundler.setup
  Bundler::GemHelper.install_tasks
rescue
  raise "You need to install a bundle first. Try 'thor version:use 3.2.13'"
end

require 'rspec'
require 'rspec/core/rake_task'
require 'cucumber/rake/task'

desc "Run all examples"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.ruby_opts = %w[-w]
  t.rspec_opts = %w[--color]
end

Cucumber::Rake::Task.new(:cucumber)

namespace :generate do
  desc "generate a fresh app with rspec installed"
  task :sample do |t|
    unless File.directory?('./tmp/sample')
      bindir = File.expand_path("bin")

      Dir.mkdir('tmp') unless File.directory?('tmp')
      sh "cp -r ./templates/sample ./tmp/sample"

      if test ?d, bindir
        Dir.chdir("./tmp/sample") do
          Dir.mkdir("bin") unless File.directory?("bin")
          sh "ln -sf #{bindir}/rake bin/rake"
          sh "ln -sf #{bindir}/rspec bin/rspec"
          sh "ln -sf #{bindir}/cucumber bin/cucumber"
        end
      end
    end
  end
end

def in_sample(command)
  Dir.chdir("./tmp/sample/") do
    Bundler.with_clean_env do
      sh command
    end
  end
end

desc 'clobber generated files'
task :clobber do
  rm_rf "pkg"
  rm_rf "tmp"
  rm_rf "doc"
  rm_rf ".yardoc"
end

namespace :clobber do
  desc "clobber the generated app"
  task :sample do
    rm_rf "tmp/sample"
  end
end

desc "Push docs/cukes to relishapp using the relish-client-gem"
task :relish, :version do |t, args|
  raise "rake relish[VERSION]" unless args[:version]
  sh "cp Changelog.md features/"
  if `relish versions rspec/rspec-activemodel-mocks`.split.map(&:strip).include? args[:version]
    puts "Version #{args[:version]} already exists"
  else
    sh "relish versions:add rspec/rspec-activemodel-mocks:#{args[:version]}"
  end
  sh "relish push rspec/rspec-activemodel-mocks:#{args[:version]}"
  sh "rm features/Changelog.md"
end

task :default => [:spec, "generate:sample", :cucumber]

task :verify_private_key_present do
  private_key = File.expand_path('~/.gem/rspec-gem-private_key.pem')
  unless File.exists?(private_key)
    raise "Your private key is not present. This gem should not be built without that."
  end
end

task :build => :verify_private_key_present
