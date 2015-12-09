module StrongPermitter
  module Manager
    def permitted_params
      permission_class = "#{self.class.name.sub('Controller', '')}Permission".camelcase.safe_constantize
      return nil unless permission_class

      resource_name = permission_class.resource_name || controller_name.singularize
      allowed_attributes = permission_class.actions[action_name]

      params.require(resource_name).permit(allowed_attributes)
    end
  end
end