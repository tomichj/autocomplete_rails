require 'autocomplete_rails/engine'
require 'autocomplete_rails/controller'

# Top level module of autocomplete_rails,
module AutocompleteRails
end

ActionController::Base.send(:include, AutocompleteRails::Controller)
