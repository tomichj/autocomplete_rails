require 'rails_autocomplete/engine'
require 'rails_autocomplete/controller'

# Top level module of rails_autocomplete,
module RailsAutocomplete
end

ActiveRecord::Base.extend RailsAutocomplete::Controller

