class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_filter :check_current_user, only: [:update]

  def me 
    render json: current_user.to_json
  end

  def update
    data = user_params
    missing_fields = fields.reject { |f| data[f].present? }

    return render json: { missing_fields: missing_fields }, status: :unprocessable_entity unless missing_fields.length == 0

    if @user.update(data)
      head :no_content
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  private
  def set_user
    @user = User.find(params[:id])
  end

  def fields
    params.require(:fields)
  end

  def user_params
    params.require(:user).permit(fields)
  end

  def check_current_user
    return head :forbiden unless @user.id == current_user.id
  end
end
