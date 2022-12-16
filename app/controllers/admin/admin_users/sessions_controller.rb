class Admin::AdminUsers::SessionsController < Devise::SessionsController
  layout 'admin/application'

  def after_sign_in_path_for(resource_or_scope)
    previous_path = super(resource_or_scope)

    unless previous_path.to_s.start_with? admin_path
      return admin_path
    end

    previous_path
  end
end
