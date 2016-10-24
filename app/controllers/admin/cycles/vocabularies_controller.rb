class Admin::Cycles::VocabulariesController < Admin::ApplicationController
  before_action :set_vocabulary, only: [:show, :edit, :update, :destroy]

  def index
    @vocabularies = @plugin_relation.vocabularies.page(params[:page]).per(qty)
  end

  def show
  end

  def new
    @vocabulary = @plugin_relation.vocabularies.new
  end

  def create
    @vocabulary = @plugin_relation.vocabularies.new vocabulary_params
    @vocabulary.cycle = @cycle

    if @vocabulary.save
      flash[:success] = "Verbete criado com sucesso."
      redirect_to url
    else
      flash[:error] = "Ocorreu algum erro ao criar o verbete."
      render :new
    end
  end

  def edit
  end

  def update
    if @vocabulary.update_attributes material_params
      flash[:success] = "Verbete atualizado com sucesso."
      redirect_to url
    else
      flash[:error] = "Ocorreu algum erro ao atualizar o verbete."
      render :edit
    end
  end

  def destroy
    if @vocabulary.destroy
      flash[:success] = "Verbete removido com sucesso."
    else
      flash[:error] = "Erro ao remover verbete."
    end

    redirect_to url
  end

  private

    def set_vocabulary
      @vocabulary = @plugin_relation.vocabularies.find params[:id]
    end

    def url
      [:admin, @cycle, @plugin_relation, :vocabularies]
    end

    def vocabulary_params
      params.require(:vocabulary).permit(
        :title,
        :description
      )
    end
end