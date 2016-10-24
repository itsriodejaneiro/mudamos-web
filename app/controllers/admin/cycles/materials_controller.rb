class Admin::Cycles::MaterialsController < Admin::ApplicationController
  before_action :set_params, only: [:create, :update]

  def index
    @materials = @plugin_relation.materials.page(params[:page]).per(qty)
  end

  def show
  end

  def new
    @material = @plugin_relation.materials.new
  end

  def create
    @material = @plugin_relation.materials.new material_params
    @material.cycle = @cycle

    if @material.save
      flash[:success] = "Material criado com sucesso."
      redirect_to [:admin, @cycle, @plugin_relation, :materials]
    else
      flash[:error] = "Ocorreu algum erro ao criar o material."
      render :new
    end
  end

  def edit
    @material = @plugin_relation.materials.find params[:id]
  end

  def update
    @material = @plugin_relation.materials.find params[:id]

    if @material.update_attributes material_params
      flash[:success] = "Material atualizado com sucesso."
      redirect_to [:admin, @cycle, @plugin_relation, :materials]
    else
      flash[:error] = "Ocorreu algum erro ao atualizar o material."
      render :edit
    end
  end

  def destroy
    @material = @plugin_relation.materials.find params[:id]

    if @material.destroy
      flash[:success] = "Material excluído com sucesso."
    else
      flash[:error] = "Erro ao excluir material."
    end

    redirect_to [:admin, @cycle, @plugin_relation, :materials]
  end

  private

    def set_params
      [:themes, :keywords].each do |attr|
        next if params[:material]["#{attr.to_s.singularize}_ids"].blank?

        params[:material][attr] = params[:material]["#{attr.to_s.singularize}_ids"].reject { |x| x.blank? }.map { |x| x.is_number? ? Material.tags_on(attr).find(x.to_i) : x }.join(';')
      end
    end

    def material_params
      params.require(:material).permit(
        :author,
        :title,
        :source,
        :category,
        :description,
        :position,
        :themes,
        :keywords
      )
    end
end
