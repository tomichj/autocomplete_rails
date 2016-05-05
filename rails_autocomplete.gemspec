$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "rails_autocomplete/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'rails_autocomplete'
  s.version     = RailsAutocomplete::VERSION
  s.authors     = ['Justin Tomich']
  s.email       = ['justin@tomich.org']
  s.homepage    = 'https://github.com/tomichj/rails_autocomplete'
  s.summary     = "Easily use jQuery's autocomplete plugin."
  s.description = "Easily use jQuery's autocomplete plugin."
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.rdoc']
  s.test_files = Dir['test/**/*']

  s.add_dependency 'rails', '~> 4.2.5'

  s.add_development_dependency 'sqlite3', '~> 1.3'
  s.add_development_dependency 'factory_girl', '~> 4.4'
  s.add_development_dependency 'rspec-rails', '~> 3.1'
  s.add_development_dependency 'rspec-mocks', '~> 3.1'
  s.add_development_dependency 'capybara', '~> 2.6'
  s.add_development_dependency 'shoulda-matchers', '~> 2.8'
  s.add_development_dependency 'database_cleaner', '~> 1.5'
  s.add_development_dependency 'timecop', '~> 0.8'
end
