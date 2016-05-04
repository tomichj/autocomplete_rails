module RailsAutocomplete
  module Controller
    def self.included(target)
      target.extend RailsAutocomplete::Controller::ClassMethods
    end

    module ClassMethods
      #
      # Generate an autocomplete controller action and routes.
      #
      # When executing your autocomplete controller action, you must have params[:search_term]
      #
      # options:
      # * :full_model - load full model, default is false
      # * :autocomplete_limit - default is 10
      # * :case_sensitive - default is false
      #
      def autocomplete(model_sym, value_method, label_method = nil, options = {})
        #
        # Add autocomplete controller method.
        #
        label_method ||= value_method
        model_constant = model_sym.to_s.camelize.constantize

        c_path = controller_path
        c_name = controller_name
        autocomplete_method_name = "autocomplete_#{model_sym}_#{value_method}"
        define_method(autocomplete_method_name) do
          results = get_autocomplete_results(model_constant, value_method, label_method, options)
          render json: build_autocomplete_json(results, value_method, label_method), root: false
        end

        Rails.application.routes.disable_clear_and_finalize = true
        Rails.application.routes.draw do
          get "/#{c_path}/autocomplete_#{model_sym}_#{value_method}",
              to: "#{c_path}#autocomplete_#{model_sym}_#{value_method}",
              as: "#{c_name}_#{autocomplete_method_name}"
        end
      end
    end

    def get_autocomplete_results(model_constant, value_method, label_method, options)
      search_term = params[:search_term]
      if search_term.blank?
        {}
      else
        results = model_constant.where(nil)
        results = results.select(autocomplete_select_clause(model_constant, value_method, label_method)) unless options[:full_model]
        results.where(autocomplete_where_clause(model_constant, search_term, value_method, options))

      end
    end

    def autocomplete_select_clause(model_constant, value_method, label_method)
      table_name = model_constant.table_name
      ["#{table_name}.#{model_constant.primary_key}", "#{table_name}.#{value_method}", "#{table_name}.#{label_method}"]
    end

    def autocomplete_where_clause(model_constant, search_term, value_method, options)
      like = (postgres?(model_constant) && !options[:case_sensitive]) ? 'ILIKE' : 'LIKE'
      table_name = model_constant.table_name
      lower = options[:case_sensitive] ? '' : 'LOWER'
      ["#{lower}(#{table_name}.#{value_method}) #{like} #{lower}(?)", search_term]
    end

    def build_autocomplete_json(results, value_method, label_method)
      results.collect do |result|
        HashWithIndifferentAccess.new id: result.id, label: result.send(label_method), value: result.send(value_method)
      end
    end

    def postgres?(model_constant)
      model_constant.connection.class.to_s.match /Postgre/
    end
  end
end
