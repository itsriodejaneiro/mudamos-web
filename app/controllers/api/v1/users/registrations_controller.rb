class Api::V1::Users::RegistrationsController < Api::V1::BaseController
  before_filter :ensure_params_exist, except: [:new]

  def new
    render json: {
      states: STATES,
      genders: User.genders,
      profiles: Profile.roots,
      alias_names: AliasName.options.pluck(:name)
    }
  end

  def create
    @user = User.new user_params

    if @user.save
      session_token = @user.ensure_session_token_for params[:platform]

      render json: {
        auth_token: session_token.token,
        user: @user
      }, status: 201
    else
      render json: formatted_error(@user.errors), status: 422
    end
  end

  def update
    @user = current_user

    if @user.update(user_update_params)
      render json: {
        user: @user
      }, status: 200
    else
      render json: formatted_error(@user.errors), status: 422
    end
  end

  def resource
    @user
  end

  private

    def ensure_params_exist
      if params[:user].blank?
        render_bad_params('user')
      end
    end

    def user_params
      #required name, email, password, password_confirmation and profile_id
      params.require(:user).permit(
        :name,
        :email,
        :password,
        :password_confirmation,
        :profile_id,
        :birthday,
        :city,
        :state,
        :gender,
        :sub_profile_id,
        :first_step,
        :alias_name,
        :alias_as_default,
        :terms,
        :picture
      )
    end

    def user_update_params
      params.require(:user).permit(
        :name,
        :email,
        :password,
        :password_confirmation,
        :profile_id,
        :birthday,
        :city,
        :state,
        :gender,
        :sub_profile_id,
        :alias_as_default,
        :picture
      )
    end

    def formatted_error errors
      {
        user:{
          errors: errors
        }
      }
    end
end

