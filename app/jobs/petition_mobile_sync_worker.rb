class PetitionMobileSyncWorker
  include Shoryuken::Worker
  shoryuken_options queue: Rails.application.secrets.queues['petition_mobile_sync'], auto_delete: true

  attr_reader :repository
  attr_reader :mobile_api_service

  def initialize(repository: PetitionPlugin::DetailVersionRepository.new, mobile_api_service: MobileApiService.new)
    @repository = repository
    @mobile_api_service = mobile_api_service
  end

  def perform(sqs_msg, body)
    petition_detail_version_id = JSON.parse(body)['id']

    Rails.logger.info "Synchronizing petition version: #{petition_detail_version_id}"

    version = repository.find_by_id petition_detail_version_id

    if version
      mobile_api_service.register_petition_version version
    else
      Rails.logger.warn "Version not found #{petition_detail_version_id}"
    end
  end
end
