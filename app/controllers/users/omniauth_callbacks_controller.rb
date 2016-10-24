class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def self.provides_callback_for(provider)
    class_eval %Q{
      def #{provider}
        auth = env["omniauth.auth"]

        @user = User.find_for_oauth(env["omniauth.auth"])

        if @user.persisted?
          sign_in(@user)
          redirect_to after_sign_in_path_for(:user)
        else
          cookies[:omniauth_auth] = {
            value: env['omniauth.auth'].to_hash.to_json,
            expires: 5.minutes.from_now
          }
          redirect_to after_sign_in_path_for(:user)
        end
      end
    }
  end

  [:twitter, :facebook, :google_oauth2].each do |provider|
    provides_callback_for provider
  end

  def after_sign_in_path_for resource
    if cookies[:after_login_path]
      if @user.persisted?
        flash[:success] = "Login efetuado com sucesso!"
        cookies[:after_login_path]
      else
        flash[:success] = "Complete seu cadastro."
        "#{cookies[:after_login_path].split("#").first}?signup"
      end
    else
      if @user.persisted?
        flash[:success] = "Login efetuado com sucesso!"
        super resource
      else
        user_registration_path
      end
    end
    # if resource.email_verified?
    #   super resource
    # else
    #   finish_signup_path(resource)
    # end
  end
end
