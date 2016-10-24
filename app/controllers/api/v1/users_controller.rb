class Api::V1::UsersController < Api::V1::BaseController
  def show
    @user = current_user
    if @user
      render json: { user: @user, profile: @user.profile, sub_profile: @user.sub_profile }, status: '201'
    else
      render_unauthorized #changed only not to break current tests with missing authentication header
    end
  end
end
