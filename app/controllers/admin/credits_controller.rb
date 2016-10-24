class Admin::CreditsController < Admin::ApplicationController
  before_action :set_credit, only: [:edit, :update, :destroy]

  def index
    @categories = CreditCategory.all
    @credits = Credit.includes(:credit_category).order('credit_categories.position ASC').page(params[:page]).per(qty)
  end

  def new
    @credit = Credit.new
    render 'form'
  end

  def create
    @credit = Credit.new credit_params

    if @credit.save
      flash[:success] = "Crédito criado com sucesso."
      redirect_to [:admin, :credits]
    else
      flash[:error] = "Erro ao criar crédito."
      render 'form'
    end
  end

  def edit
    render 'form'
  end

  def update
    if @credit.update_attributes credit_params
      flash[:success] = "Crédito atualizado com sucesso."
      redirect_to [:admin, :credits]
    else
      flash[:error] = "Erro ao atualizar crédito."
      render 'form'
    end
  end

  def destroy
    if @credit.destroy
      flash[:success] = "Crédito removido com sucesso."
    else
      flash[:error] = "Erro ao excluir crédito."
    end

    redirect_to [:admin, :credits]
  end

  private

    def set_credit
      @credit = Credit.find params[:id]
    end

    def credit_params
      params.require(:credit).permit(
        :name,
        :url,
        :credit_category_id,
        :content
      )
    end
end
