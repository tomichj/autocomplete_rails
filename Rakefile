require 'bundler/setup'
require 'bundler/gem_tasks'
require 'appraisal'

require 'rdoc/task'

RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'AutocompleteRails'
  rdoc.options << '--line-numbers'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

APP_RAKEFILE = File.expand_path('../spec/dummy/Rakefile', __FILE__)
load 'rails/tasks/engine.rake'
load 'rails/tasks/statistics.rake'
require 'rspec/core/rake_task'

namespace :dummy do
  require_relative "spec/dummy/config/application"
  Dummy::Application.load_tasks
end

RSpec::Core::RakeTask.new(:spec)

desc 'Run all specs in spec directory (excluding plugin specs)'
task default: :spec

task :build do
  system "gem build autocomplete_rails.gemspec"
end

task release: :build do
  system "gem push bundler-#{AutocompleteRails::VERSION}"
end
