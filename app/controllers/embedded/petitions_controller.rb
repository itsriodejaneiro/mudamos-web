class Embedded::PetitionsController < Embedded::ApplicationController
  before_action :set_petition, only: [:show]

  attr_reader :petition_detail_repository

  def initialize(petition_detail_repository: PetitionPlugin::DetailRepository.new)
    @petition_detail_repository = petition_detail_repository
  end

  def show
  end

  helper_method :generate_link
  def generate_link
    cycle_plugin_relation_url(
      phase.cycle,
      phase.plugin_relation
    )
  end

  helper_method :phase
  def phase
    @petition.plugin_relation.related
  end

  private

  def set_petition
    @petition = petition_detail_repository.find_by_id!(params[:id])
  end
end
