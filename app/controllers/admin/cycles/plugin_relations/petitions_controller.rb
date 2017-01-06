class Admin::Cycles::PluginRelations::PetitionsController < Admin::ApplicationController
  def index
    @petition = @plugin_relation.petition_detail
  end

  def new
    @petition = PetitionPlugin::Detail.new
  end

  def edit
    @petition = @plugin_relation.petition_detail
  end

  def update
    @petition = @plugin_relation.petition_detail
    @petition.update_attributes petition_params

    current_version = @petition.current_version
    if current_version.nil? || current_version.body != petition_versionable_params[:body]
      @petition.petition_detail_versions << PetitionPlugin::DetailVersion.new(petition_versionable_params)
    end

    if @petition.save
      flash[:success] = "Petição salva com sucesso."
      redirect_to [:admin, @cycle, @plugin_relation, :petitions]
    else
      flash[:error] = "Ocorreu algum erro ao atualizar a petição."
      render :edit
    end
  end

  def create
    @petition = PetitionPlugin::Detail.new(plugin_relation_id: @plugin_relation.id)
    @petition.update_attributes petition_params

    @petition.petition_detail_versions << PetitionPlugin::DetailVersion.new(petition_versionable_params)

    if @petition.save
      flash[:success] = "Petição salva com sucesso."
      redirect_to [:admin, @cycle, @plugin_relation, :petitions]
    else
      flash[:error] = "Ocorreu algum erro ao criar a petição."
      render :new
    end
  end

  private

  def petition_params
    params.require(:petition_plugin_detail)
      .permit(:call_to_action, :signatures_required, :presentation)
  end

  def petition_versionable_params
    params.require(:petition_plugin_detail).require(:current_version)
      .permit(:document_url, :body)
  end
end
