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

    if detail_updater.perform @petition, petition_params, petition_body
      enqueue_pdf_generation
      flash[:success] = "Petição salva com sucesso."
      redirect_to [:admin, @cycle, @plugin_relation, :petitions]
    else
      flash[:error] = "Ocorreu algum erro ao atualizar a petição."
      render :edit
    end
  end

  def create
    if @plugin_relation.petition_detail
      flash[:error] = "Esta petição já foi salva por outra pessoa, tente novamente clicando em Editar Petição"
      return redirect_to [:admin, @cycle, @plugin_relation, :petitions]
    end

    @petition = PetitionPlugin::Detail.new(plugin_relation_id: @plugin_relation.id)

    if detail_updater.perform @petition, petition_params, petition_body
      enqueue_pdf_generation
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

  def petition_body 
    params.require(:petition_plugin_detail).require(:current_version).permit(:body)[:body]
  end

  def enqueue_pdf_generation
    version = @petition.petition_detail_versions.where(published: false).first
    PetitionPdfGenerationWorker.perform_async id: version.id if version
  end

  def detail_updater
    @detail_updater ||= PetitionPlugin::DetailUpdater.new
  end
end
