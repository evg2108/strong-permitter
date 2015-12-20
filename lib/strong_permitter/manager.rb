module StrongPermitter
  module Manager
    def permitted_params
      permission_class = "#{self.class.name.sub('Controller', '')}Permission".camelcase.safe_constantize
      return nil unless permission_class

      action_hash = permission_class.actions[action_name]

      resource_name = action_hash[:resource] || permission_class.resource_name || controller_name.singularize
      allowed_params = action_hash[:permitted_params]

      params.require(resource_name).permit(allowed_params)
    end
  end
end