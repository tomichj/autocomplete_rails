module AutocompleteRails
  module Controller
    def self.included(target)
      target.extend AutocompleteRails::Controller::ClassMethods
    end

    module ClassMethods
      #
      # Generate an autocomplete controller action.
      #
      # The generated method is named  "autocomplete_#{model_class}_#{value_method}", e.g.
      #
      #   class ProductController
      #     autocomplete :user, :email
      #   end
      #
      # generates a method named autocomplete_user_email.
      #
      # Parameters:
      # * model_class - symbol of the model class to autocomplete.
      # * value_method - symbol of the method on model to autocomplete, supplies the 'value' field in results.
      #                  Also used as the label unless you supply options[:label_method]
      # * options - hash of optional settings.
      #
      # Options:
      # * :label_method - call a separate method for the label, otherwise defaults to value_method. If your label
      #                   method is a method that is *not* a column in your DB, you may need options[:full_model].
      # * :full_model - load full model instead of only selecting the specified values. Default is false.
      # * :limit - default is 10.
      # * :case_sensitive - default is false.
      # * :additional_data - collect additional data. Will be added to select unless full_model is invoked.
      # * :full_search - search the entire value string for the term. Defaults to false, in which case the string must
      #                  start with the term.
      # * :scopes - limit query to these scopes, passed in as an array, e.g. scopes: [:scope1, :scope2]
      #
      # Be sure to add a route to the generated controller method.
      #
      def autocomplete(model_class, value_method, options = {})
        label_method = options[:label_method] || value_method
        model_constant = model_class.to_s.camelize.constantize
        autocomplete_method_name = "autocomplete_#{model_class}_#{value_method}"

        define_method(autocomplete_method_name) do
          results = autocomplete_results(model_constant, value_method, label_method, options)
          render json: autocomplete_build_json(results, value_method, label_method, options), root: false
        end
      end
    end

    protected

    def autocomplete_results(model_class, value_method, label_method = nil, options)
      search_term = params[:term]
      return {} if search_term.blank?
      results = model_class.where(nil) # make an empty scope to add select, where, etc, to.

      scopes  = Array(options[:scopes])
      scopes.each { |scope| results = results.send(scope) } unless scopes.empty?

      results = results.select(autocomplete_select_clause(model_class, value_method, label_method, options)) unless
        options[:full_model]
      results.
        where(autocomplete_where_clause(search_term, model_class, value_method, options)).
        limit(autocomplete_limit_clause(options)).
        order(autocomplete_order_clause(model_class, value_method, options))
    end

    def autocomplete_select_clause(model_class, value_method, label_method, options)
      table_name = model_class.table_name
      selects = []
      selects << "#{table_name}.#{model_class.primary_key}"
      selects << "#{table_name}.#{value_method}"
      selects << "#{table_name}.#{label_method}" if label_method
      options[:additional_data].each { |datum| selects << "#{table_name}.#{datum}" } if options[:additional_data]
      selects
    end

    def autocomplete_where_clause(term, model_class, value_method, options)
      term = "#{term.gsub(/([_%\\])/, '\\\\\1')}" # escape any _'s or %'s in the search term
      term = "#{term}%"
      term = "%#{term}" if options[:full_search]
      table_name = model_class.table_name
      lower = options[:case_sensitive] ? '' : 'LOWER'
      ["#{lower}(#{table_name}.#{value_method}) LIKE #{lower}(?) ESCAPE \"\\\"", term]
    end

    def autocomplete_limit_clause(options)
      options[:limit] ||= 10
    end

    def autocomplete_order_clause(model_class, value_method, options)
      return options[:order] if options[:order]

      # default to ASC order
      table_prefix = "#{model_class.table_name}."
      "LOWER(#{table_prefix}#{value_method}) ASC"
    end

    def autocomplete_build_json(results, value_method, label_method, options)
      results.collect do |result|
        data = HashWithIndifferentAccess.new(id: result.id,
                                             label: result.send(label_method),
                                             value: result.send(value_method))
        options[:additional_data].each do |method|
          data[method] = result.send(method)
        end if options[:additional_data]
        data
      end
    end

    def postgres?(model_class)
      model_class.connection.class.to_s.match /Postgre/
    end
  end
end
