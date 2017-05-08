class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_filter :check_current_user, only: [:update]

  attr_writer :account_remover

  def account_remover
    @account_remover ||= PetitionPlugin::AccountRemover.new
  end

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

  def remove_account
    result = account_remover.perform(email: remove_account_params[:email])

    if result.success
      render json: { message: I18n.t(:success, scope: %i(actions remove_account))}
    else
      head 422
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

  def remove_account_params
    params.require(:user).permit(:email)
  end
end
