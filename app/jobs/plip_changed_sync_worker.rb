class PlipChangedSyncWorker
  include Shoryuken::Worker

  shoryuken_options queue: Rails.application.secrets.queues["plip_changed_sync"], auto_delete: true

  attr_accessor :plip_repository
  attr_accessor :mobile_api_service

  def initialize(plip_repository: PlipRepository.new, mobile_api_service: MobileApiService.new)
    @plip_repository = plip_repository
    @mobile_api_service = mobile_api_service
  end

  def perform(sqs_msg, body)
    detail_id = JSON.parse(body)["id"]
    plip = plip_repository.find_plip_by_id(detail_id)

    unless plip
      logger.info "Plip detail not found. ID: #{detail_id}"
      return
    end

    mobile_api_service.sync_plip(plip)
    logger.info "Plip synced. ID: #{detail_id}"
  end

  def logger
    Rails.logger
  end
end
