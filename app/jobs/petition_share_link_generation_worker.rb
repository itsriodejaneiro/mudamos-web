class PetitionShareLinkGenerationWorker
  include Shoryuken::Worker
  shoryuken_options queue: Rails.application.secrets.queues['petition_share_link_generation'], auto_delete: true

  attr_reader :petition_share_link_service
  attr_reader :repository

  def initialize(petition_share_link_service: PetitionShareLinkService.new, repository: PetitionPlugin::DetailRepository.new)
    @petition_share_link_service = petition_share_link_service
    @repository = repository
  end

  def perform(sqs_msg, body)
    petition_detail_id = JSON.parse(body)['id']
    petition_detail = repository.find_by_id!(petition_detail_id)
    phase = petition_detail.plugin_relation.related

    url = petition_share_link_service.generate(phase)

    petition_detail.share_link = url
    petition_detail.save!

    PlipChangedSyncWorker.perform_async id: petition_detail.id if petition_detail.published_version
    Rails.logger.info "Plip sync enqueued. ID: #{detail_id}"
  end
end
