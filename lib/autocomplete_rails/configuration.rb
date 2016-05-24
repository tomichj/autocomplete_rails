module AutocompleteRails
  class Configuration
    attr_accessor :routes

    def initialize
      @routes = true
    end

    # @return [Boolean] are Invitation's built-in routes enabled?
    def routes_enabled?
      @routes
    end
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configuration=(config)
    @configuration = config
  end

  def self.configure
    yield configuration
  end
end
