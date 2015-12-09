module StrongPermitter
  module Permission
    class Base
      class << self
        def actions
          @actions ||= HashWithIndifferentAccess.new { |hash,val| hash[val] = [] }
        end

        def create_params(*param_names)
          allowed_params_for :create, *param_names
        end

        def update_params(*param_names)
          allowed_params_for :update, *param_names
        end

        def allowed_params_for(action_name, *param_names)
          actions[action_name] = param_names
        end

        def resource_name=(name)
          @resource_name ||= name
        end

        def resource_name
          @resource_name
        end
      end
    end
  end
end