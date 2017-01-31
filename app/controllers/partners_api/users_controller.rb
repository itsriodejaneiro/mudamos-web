class PartnersApi::UsersController < PartnersApi::ApplicationController
  def create
    user_params = params.permit(:email, :name, :encrypted_password)

    user = User.new(name: user_params["name"], email: user_params["email"], password: user_params["encrypted_password"])
    
    if user.save
      user.update_attribute :encrypted_password, user_params["encrypted_password"]
      head 204
    else
      render json: user.errors, status: 422
    end
  end
end
