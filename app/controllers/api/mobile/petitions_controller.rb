class Api::Mobile::PetitionsController < ActionController::Base

  attr_reader :petition_cached_service

  def initialize(petition_cached_service: PetitionCachedService.new)
    @petition_cached_service = petition_cached_service
  end

  def show
    petition_id = params[:id]

    petition_info = petition_cached_service.fetch_petition_info(petition_id)

    render json: petition_info
    expires_in 1.day, public: true
  end

  private
end
