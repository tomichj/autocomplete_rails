require 'rails_autocomplete/engine'
require 'rails_autocomplete/controller'

# Top level module of rails_autocomplete,
module RailsAutocomplete
end

ActionController::Base.send(:include, RailsAutocomplete::Controller)
