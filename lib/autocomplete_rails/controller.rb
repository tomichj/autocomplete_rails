module AutocompleteRails
  module Controller
    def self.included(target)
      target.extend AutocompleteRails::Controller::ClassMethods
    end

    module ClassMethods
      #
      # Generate an autocomplete controller action.
      #
      # Parameters:
      # * model_sym - the model to autocomplete.
      # * value_method - method on model to autocomplete, supplies the 'value' field in results. Also used
      #                  as the label unless you supply options[:label_method]
      # * options - hash of optional settings.
      #
      # Options:
      # * :label_method - call a separate method for the label, otherwise defaults to value_method. If your label
      #                   method is a method that is *not* a column in your DB, then also use options[:full_model].
      # * :full_model - load full model instead of only selecting the specified values. Default is false.
      # * :limit - default is 10.
      # * :case_sensitive - default is false.
      # * :additional_data - collect additonal data. Will be added to select unless full_model is invoked.
      #
      # The resulting autocomplete controller method name is
      #   autocomplete_#{model}
      #
      def autocomplete(model_sym, value_method, options = {})
        label_method = options[:label_method] || value_method
        model_constant = model_sym.to_s.camelize.constantize
        autocomplete_method_name = "autocomplete_#{model_sym}_#{value_method}"

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
      results = results.select(autocomplete_select_clause(model_class, value_method, label_method, options)) unless
        options[:full_model]
      results.where(autocomplete_where_clause(search_term, model_class, value_method, options)).
        limit(autocomplete_limit_clause(options)).
        order(autocomplete_order_clause(model_class, value_method, options))
      results
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

    def autocomplete_where_clause(search_term, model_class, value_method, options)
      table_name = model_class.table_name
      lower = options[:case_sensitive] ? '' : 'LOWER'
      ["#{lower}(#{table_name}.#{value_method}) LIKE #{lower}(?)", search_term]
    end

    def autocomplete_limit_clause(options)
      options[:limit] || 10
    end

    def autocomplete_order_clause(model_class, value_method, options)
      return options[:order] if options[:order]
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
