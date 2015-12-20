module StrongPermitter
  module Permission
    class Base
      class << self
        def actions
          @actions ||= HashWithIndifferentAccess.new { |hash,val| hash[val] = [] }
        end

        def create_params(*param_names_and_options)
          allowed_params_for :create, *param_names_and_options
        end

        def update_params(*param_names_and_options)
          allowed_params_for :update, *param_names_and_options
        end

        def allowed_params_for(action_name, *param_names_and_options)
          options = extract_options!(param_names_and_options)
          param_names = param_names_and_options

          resource_name = get_resource_name(options)

          action_hash = { permitted_params: param_names }
          action_hash[:resource] = resource_name if resource_name

          actions[action_name] = action_hash
        end

        def resource_name=(name)
          @resource_name ||= name
        end

        def resource_name
          @resource_name
        end

        private

        def extract_options!(param_names_and_options)
          if param_names_and_options.last.is_a?(Hash)
            if param_names_and_options[:resource]
              options = param_names_and_options.keys.length == 1 ?
                  param_names_and_options.pop :
                  param_names_and_options.delete(:resource)
            end
          end
          options || {}
        end

        def get_resource_name(options)
          options.is_a?(Hash) && options[:resource]
        end
      end
    end
  end
end