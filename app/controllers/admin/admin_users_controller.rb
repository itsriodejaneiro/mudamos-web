class Admin::AdminUsersController < Admin::ApplicationController
  before_action :admin_must_be_master!

  before_action :set_admin_user, only: [:show, :edit, :update, :destroy]

  def index
    respond_to do |format|
      format.html {
        qty = params[:qty] || 10
        if params[:order_by_type] == 'true' or params[:order_by_type] == true
          @admin_users = AdminUser.order(:last_sign_in_at)
        else
          @admin_users = AdminUser.order(:name)
        end
        @admin_users = @admin_users.page(params[:page]).per(qty)
      }
      format.csv {
        send_csv AdminUser.all.to_csv, 'administradores'
      }
    end
  end

  def show
  end

  def new
    @admin_user = AdminUser.new
  end

  def create
    @admin_user = AdminUser.new admin_user_params
    if @admin_user.save
      flash[:success] = "Administrador criado com sucesso."
      redirect_to [:admin, :admin_users]
    else
      flash[:error] = "Ocorreu um erro ao criar o administrador."
      render :new
    end
  end

  def edit
  end

  def update
    if @admin_user.update_attributes admin_user_params
      flash[:success] = "Administrador atualizado com sucesso."
      redirect_to [:admin, :admin_users]
    else
      flash[:error] = "Ocorreu um erro ao atualizar o administrador."
      render :edit
    end
  end

  def destroy
    if @admin_user.destroy
      flash[:success] = "Administrador removido com sucesso."
    else
      flash[:error] = "Ocorreu um erro ao remover o administrador."
    end

    redirect_to [:admin, :admin_users]
  end

  def bulk_destroy
    if params[:ids].blank?
      flash[:error] = "Você deve seleconiar pelo menos um administrador."
    else
      params[:ids].each do |id|
        admin_user = AdminUser.find id
        admin_user.destroy
        flash[:success] = "Administradores removidos com sucesso."
      end
    end

    redirect_to [:admin, :admin_users]
  end

  private

    def set_admin_user
      @admin_user = AdminUser.find params[:id]
    end

    def admin_user_params
      params.require(:admin_user).permit(:email, :name, :password, :password_confirmation, :admin_type)
    end
end
