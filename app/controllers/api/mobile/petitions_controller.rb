class Api::Mobile::PetitionsController < ActionController::Base

  attr_reader :mobile_service

  def initialize(mobile_service: MobileApiService.new)
    @mobile_service = mobile_service
  end

  def show
    petition_id = params[:id]

    petition_info = Rails.cache.fetch("mobile_petition_info:#{petition_id}", expires_in: cache_time) do
      mobile_service.petition_info(petition_id)
    end

    render json: petition_info
    expires_in cache_time, public: true
  end

  private

  # Should we make this configurable? By env vars for example?
  def cache_time
    1.minutes
  end
end
