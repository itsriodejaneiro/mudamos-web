class PartnersApi::UsersController < PartnersApi::ApplicationController

  attr_reader :user_service

  def initialize(user_service: UserService.new)
    @user_service = user_service
  end

  def create
    user_params = params.permit(:email, :name, :encrypted_password)
    user = user_service.create_user_with_password(
      email: user_params["email"],
      name: user_params["name"],
      encrypted_password: user_params["encrypted_password"]
    )
    
    if user.valid?
      head 204
    else
      render json: user.errors, status: 422
    end
  end
end
