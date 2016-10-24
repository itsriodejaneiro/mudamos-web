class Admin::CreditCategoriesController < Admin::ApplicationController
  before_action :set_credit_category, only: [:edit, :update, :destroy]

  def new
    @credit_category = CreditCategory.new
    render 'form'
  end

  def create
    @credit_category = CreditCategory.new credit_category_params

    if @credit_category.save
      flash[:success] = "Categoria criada com sucesso."
      redirect_to [:admin, :credits]
    else
      flash[:error] = "Erro ao criar categoria."
      render 'form'
    end
  end

  def edit
    render 'form'
  end

  def update
    if @credit_category.update_attributes credit_category_params
      flash[:success] = "Categoria atualizada com sucesso."
      redirect_to [:admin, :credits]
    else
      flash[:error] = "Erro ao atualizar categoria."
      render 'form'
    end
  end

  def destroy
    if @credit_category.destroy
      flash[:success] = "Categoria removida com sucesso."
    else
      flash[:error] = "Erro ao excluir categoria."
    end

    redirect_to [:admin, :credits]
  end

  private

    def set_credit_category
      @credit_category = CreditCategory.find params[:id]
    end

    def credit_category_params
      params.require(:credit_category).permit(
        :name,
        :position
      )
    end
end
