class Users::RegistrationsController < Devise::RegistrationsController
  before_filter :configure_permitted_parameters
  respond_to :js

  def new
    render 'cycles/index'
  end

  def create
    begin
      build_resource sign_up_params

      unless resource.first_step
        if cookies[:user_photo] and resource.picture.blank?
          resource.picture = cookies[:user_photo]
        end

        if cookies[:omniauth_identity]
          begin
            resource.omniauth_identities = [OmniauthIdentity.new(JSON.parse(cookies[:omniauth_identity]))]
          rescue Exception => e
            cookies.delete(:omniauth_identity)
          end
        end

        if resource.save
          if Rails.env.production?
            session[:new_user_created] = true
          end

          if resource.active_for_authentication?
            sign_up(:user, resource)
            flash[:success] = "Login efetuado com sucesso."

            render json: {
              resource: resource,
              location: after_sign_up_path_for(resource),
              csrf_token: form_authenticity_token
            }
          else
            expire_data_after_sign_in!
            flash[:success] = "Cadastro realizado mas ainda é preciso confirmar sua conta antes de acessar."

            render json: {
              resource: resource,
              location: after_inactive_sign_up_path_for(resource),
              csrf_token: form_authenticity_token
            }
          end
        end
      end
    rescue Exception => e
      puts "\n\n BUG NO LOGIN \n\n"
    end
  end

  private

    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) do |u|
        u.permit(:name, :email, :password, :password_confirmation, :birthday, :picture, :gender, :state, :city, :profile, :profile_id, :sub_profile, :sub_profile_id, :alias_as_default, :alias_name, :first_step, :terms)
      end
      devise_parameter_sanitizer.for(:account_update) do |u|
        u.permit(:name, :email, :password, :password_confirmation, :birthday, :picture, :gender, :state, :city, :profile, :profile_id, :sub_profile, :sub_profile_id, :alias_as_default, :alias_name)
      end
    end

  protected

    def update_resource(resource, params)
      resource.update_without_password(params)
    end
end
