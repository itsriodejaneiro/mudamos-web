class PetitionsController < ApplicationController
  def verify
  end

  def signatures
    @petition = petition_repository.find_by_id!(params[:petition_id])
    @signatures = petition_service.fetch_petition_signatures(params[:petition_id])
  end

  private

  def petition_service
    @petition_service ||= PetitionService.new
  end

  def petition_repository
    @petition_repository ||= PetitionPlugin::DetailRepository.new
  end
end
