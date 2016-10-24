class Users::SessionsController < Devise::SessionsController
  respond_to :js

  def new
    render 'cycles/index'
  end

  def create
    self.resource = warden.authenticate!(auth_options)
    # set_flash_message(:notice, :signed_in) if is_flashing_format?
    sign_in(resource_name, resource)

    yield resource if block_given?

    flash[:success] = "Login efetuado com sucesso!"
    
    render json: {
      resource: resource,
      location: after_sign_in_path_for(resource),
      csrf_token: form_authenticity_token
    }
  end

  def auth_options
    { scope: resource_name, recall: "#{controller_path}#render_create" }
  end

  def render_create
    render 'users/sessions/create'
  end
end


# class MyDevise::SessionsController < Devise::SessionsController
#   layout :false, only: [:new]
#   respond_to :js
#   # skip_before_filter :verify_authenticity_token, only: [:create]

#   def new
#     flash.keep
#     redirect_to root_path(login: true)
#   end

#   def auth_options
#     { scope: resource_name, recall: "#{controller_path}#render_create" }
#   end

#   # def auth_options
#   #   { scope: resource_name, recall: "#{controller_path}#new" }
#   # end

#   def render_create
#     self.resource = resource_class.new(sign_in_params)

#     self.resource.errors.add :email, 'não pode ficar em branco.' if resource.email.blank?
#     self.resource.errors.add :password, 'não pode ficar em branco.' if resource.password.blank?

#     self.resource.errors.add :password, 'ou e-mail inválidos.' if self.resource.errors.blank?

#     render 'users/sessions/create'
#   end
# end
