class Admin::Cycles::PluginRelations::PetitionsController < Admin::ApplicationController
  def index
    @petition = @plugin_relation.petition_detail
    @dynamic_link_metrics = dynamic_link_metrics.perform @petition
  end

  def new
    @petition = PetitionPlugin::Detail.new
  end

  def edit
    @petition = @plugin_relation.petition_detail
  end

  def update
    @petition = @plugin_relation.petition_detail

    response = detail_updater.perform @petition, petition_params, petition_body
    if response.success
      enqueue_pdf_generation response
      enqueue_plip_sync response

      flash[:success] = "Projeto de Lei salvo com sucesso."
      redirect_to [:admin, @cycle, @plugin_relation, :petitions]
    else
      flash[:error] = "Ocorreu algum erro ao atualizar o Projeto de Lei."
      render :edit
    end
  end

  def create
    if @plugin_relation.petition_detail
      flash[:error] = "Esta petição já foi salva por outra pessoa, tente novamente clicando em Editar Projeto de Lei"
      return redirect_to [:admin, @cycle, @plugin_relation, :petitions]
    end

    @petition = PetitionPlugin::Detail.new(plugin_relation_id: @plugin_relation.id)

    response = detail_updater.perform @petition, petition_params, petition_body
    if response.success
      enqueue_pdf_generation response
      flash[:success] = "Projeto de Lei salvo com sucesso."
      redirect_to [:admin, @cycle, @plugin_relation, :petitions]
    else
      flash[:error] = "Ocorreu algum erro ao criar a petição."
      render :new
    end
  end

  helper_method :past_versions
  def past_versions
    detail_repository.past_versions_desc(@petition.id)
  end

  private

  def detail_repository
    @detail_repository ||= PetitionPlugin::DetailRepository.new
  end

  def petition_params
    params.require(:petition_plugin_detail)
      .permit(%i(
        call_to_action
        initial_signatures_goal
        signatures_required
        presentation
        video_id
        scope_coverage
        city_id
        uf
      ))
  end

  def petition_body
    params.require(:petition_plugin_detail).require(:current_version).permit(:body)[:body]
  end

  def enqueue_pdf_generation(use_case_response)
    PetitionPdfGenerationWorker.perform_async id: use_case_response.version.id if use_case_response.version
  end

  def enqueue_plip_sync(use_case_response)
    PlipChangedSyncWorker.perform_async id: use_case_response.detail.id unless use_case_response.version
  end

  def detail_updater
    @detail_updater ||= PetitionPlugin::DetailUpdater.new
  end

  def dynamic_link_metrics
    @dynamic_link_metrics_dafault ||= PetitionPlugin::DynamicLinkMetrics.new
  end
end
