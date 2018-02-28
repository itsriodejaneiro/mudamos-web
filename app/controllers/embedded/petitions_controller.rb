class Embedded::PetitionsController < Embedded::ApplicationController
  caches_action :show, expires_in: 5.minutes, cache_path: -> do
    params.slice(:flags)
  end

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

  helper_method :petition
  def petition
    @petition ||= petition_detail_repository.find_by_id!(params[:id])
  end

  helper_method :phase
  def phase
    petition.plugin_relation.related
  end

  helper_method :cycle
  def cycle
    phase.cycle
  end
end
