$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require 'autocomplete_rails/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'autocomplete_rails'
  s.version     = AutocompleteRails::VERSION
  s.authors     = ['Justin Tomich']
  s.email       = ['justin@tomich.org']
  s.homepage    = 'https://github.com/tomichj/autocomplete_rails'
  s.summary     = "Easily use jQuery UI's autocomplete widget with Rails applications."
  s.description = "Easily use jQuery UI's autocomplete widget with Rails applications."
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.rdoc']
  s.test_files = Dir['test/**/*']

  s.add_dependency 'rails', '>= 4.0', '< 5.3'

  s.add_development_dependency 'factory_bot', '~> 4.10.0'
  s.add_development_dependency 'rspec-rails', '~> 3.1'
  s.add_development_dependency 'rspec-mocks', '~> 3.1'
  s.add_development_dependency 'shoulda-matchers', '~> 2.8'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'bundler'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'appraisal'
end
