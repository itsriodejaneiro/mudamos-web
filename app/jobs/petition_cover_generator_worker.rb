class PetitionCoverGeneratorWorker
  include Shoryuken::Worker
  shoryuken_options queue: Rails.application.secrets.queues['petition_cover_generation'], auto_delete: true

  attr_reader :petition_cover_service
  attr_reader :repository

  def initialize(petition_cover_service: PetitionCoverService.new, repository: PetitionPlugin::DetailVersionRepository.new)
    @petition_cover_service = petition_cover_service
    @repository = repository
  end

  def perform(sqs_msg, body)
    petition_detail_version_id = JSON.parse(body)['id']
    Rails.logger.info "Processing plugin detail version: #{petition_detail_version_id}"

    version = repository.find_by_id! petition_detail_version_id

    result = petition_cover_service.generate!(version)
    Rails.logger.info "Cover files generated: #{result.files}"
  end
end
