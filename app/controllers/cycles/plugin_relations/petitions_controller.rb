class Cycles::PluginRelations::PetitionsController < ApplicationController
  before_action :ensure_user, only: :sign
  before_action -> { check_if_user_can_interact_with! "Petição" }, only: :sign

  attr_writer :petition_signer

  def petition_signer
    @petition_signer ||= PetitionPlugin::PetitionSigner.new
  end

  attr_writer :plugin_relation_repository

  def plugin_relation_repository
    @plugin_relation_repository ||= PluginRelationRepository.new
  end

  attr_writer :detail_version_repository

  def detail_version_repository
    @detail_version_repository ||= PetitionPlugin::DetailVersionRepository.new
  end

  def sign
    return render json: { error: "Fase terminada" }, status: 403 unless plugin_relation.related.in_progress?

    detail_version = detail_version_repository.find_published_by_relation_id(plugin_relation.id)

    return render json: { error: "Projeto não encontrado" }, status: 404 unless detail_version

    petition_signer.perform user: current_user, petition_detail_version: detail_version

    flash[:success] = "Petição assinada!"
    head :ok
  end

  private

  def ensure_user
    head :ok unless user_signed_in?
  end

  def plugin_relation
    @plugin_relation ||= plugin_relation_repository.find_by_id!(params[:plugin_relation_id])
  end

  def plugin_type
    @plugin_type ||= PluginType::Petition.new
  end
end
