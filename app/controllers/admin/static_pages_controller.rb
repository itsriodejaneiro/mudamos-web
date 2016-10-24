class Admin::StaticPagesController < Admin::ApplicationController
  before_action :set_static_page, only: [:show, :edit, :update, :destroy]

  def show
  end

  def new
    @static_page = StaticPage.new
    render 'form'
  end

  def create
    @static_page = StaticPage.new static_page_params

    if @static_page.save
      flash[:success] = "Página criada com sucesso."
      redirect_to [:admin, @static_page]
    else
      flash[:error] = "Erro ao criar página."
      render 'form'
    end
  end

  def edit
    render 'form'
  end

  def update
    if @static_page.update_attributes static_page_params
      flash[:success] = "Página atualizada com sucesso."
      redirect_to [:admin, @static_page]
    else
      flash[:error] = "Erro ao atualizar página."
      render 'form'
    end
  end

  def destroy
    if @static_page.destroy
      flash[:success] = "Página removida com sucesso."
    else
      flash[:error] = "Erro ao excluir página."
    end

    redirect_to [:admin]
  end

  private

    def set_static_page
      @static_page = StaticPage.find params[:id]
    end

    def static_page_params
      params.require(:static_page).permit(
        :name,
        :title,
        :content,
        :show_on_header,
        :show_on_footer
      )
    end
end
