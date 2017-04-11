module Requests
  module JsonHelpers
    def json
      JSON.parse(response.body)
    end
  end
end

#
# Dumb glue method, deal with rails 4 vs rails 5
#
def do_get(path, *args)
  if Rails::VERSION::MAJOR >= 5
    get path, *args
  else
    get path, *(args.collect{|i| i.values}.flatten)
  end
end

RSpec.configure do |config|
  config.include Requests::JsonHelpers, type: :request
end
