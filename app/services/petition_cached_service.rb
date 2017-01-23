class PetitionCachedService

  attr_reader :mobile_service

  def initialize(mobile_service: MobileApiService.new)
    @mobile_service = mobile_service
  end

  def fetch_petition_info(petition_id)
    petition_info = Rails.cache.fetch("mobile_petition_info:#{petition_id}") do
      mobile_service.petition_info(petition_id)
    end
  end
end
