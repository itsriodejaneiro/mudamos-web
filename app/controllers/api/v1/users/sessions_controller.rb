class Api::V1::Users::SessionsController < Api::V1::BaseController
  before_filter :ensure_params_exist, :except => [:destroy]
  respond_to :json

  def create
    platform = params[:platform]
    @user = User.find_by_email params[:user][:email]
    return invalid_login_attempt unless @user

    if @user.valid_password? params[:user][:password]
      sign_in :user, @user
      auth_token = @user.ensure_session_token_for platform

      render json: {
        auth_token: auth_token.token,
        user: @user
      }, status: 201
    else
      invalid_login_attempt
    end
  end

  def destroy
    @user = current_user
    if @user
      @user.destroy_latest_token params[:platform]
      sign_out @user
      render json: {}.to_json, status: :ok
    else
      render_unauthorized #changed only not to break current tests with missing authentication header
    end
  end

  def resource
    @user
  end

  protected
    def ensure_params_exist
      if params[:user].blank?
        render_bad_params 'user'
      end
    end

    def invalid_login_attempt
      render json:{
        user: {
          errors: {
            login: [
              'Login ou senha incorretos'
            ]
          }
        }
      }, status: 422
    end
end

