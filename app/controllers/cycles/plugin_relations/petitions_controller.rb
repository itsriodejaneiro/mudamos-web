class Cycles::PluginRelations::PetitionsController < ApplicationController
  before_action :ensure_user, only: :sign
  before_action -> { check_with_user_can_interact_with! "Petição" }, only: :sign

  attr_writer :petition_signer

  def petition_signer
    @petition_signer ||= PetitionPlugin::PetitionSigner.new
  end

  attr_writer :plugin_relation_repository

  def plugin_relation_repository
    @plugin_relation_repository ||= PluginRelationRepository.new
  end

  def sign
    petition_signer.perform user_id: current_user.id, plugin_relation_id: plugin_relation.id

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
