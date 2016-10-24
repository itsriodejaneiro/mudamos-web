class Api::V1::Users::PasswordsController < Api::V1::BaseController
  def create
    @user = User.send_reset_password_instructions(user_params)

    if @user.errors.empty?
      render status: 200, nothing: true
    else
      render status: 404, json: {
        errors: {
          user: {
            email: [
              t(:does_not_exist)
            ]
          }
        }
      }
    end
  end

  private

    def user_params
      params.require(:user).permit(
        :email
      )
    end
end
