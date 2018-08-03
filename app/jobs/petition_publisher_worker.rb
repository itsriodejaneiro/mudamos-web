class PetitionPublisherWorker
  include Shoryuken::Worker
  shoryuken_options queue: Rails.application.secrets.queues['petition_publisher'], auto_delete: true

  attr_reader :repository
  attr_accessor :petition_service

  def initialize(
    repository: PetitionPlugin::DetailVersionRepository.new,
    petition_service: PetitionService.new
  )
    @repository = repository
    @petition_service = petition_service
  end

  def perform(sqs_msg, body)
    petition_detail_version_id = JSON.parse(body)['id']

    version = repository.find_by_id petition_detail_version_id

    if version
      version.update! published: true
      Rails.logger.info "Version published #{petition_detail_version_id}"

      enqueue_share_link version.petition_plugin_detail_id

      refresh_caches version
    else
      Rails.logger.warn "Version not found #{petition_detail_version_id}"
    end
  end

  def enqueue_share_link(detail_id)
    PetitionShareLinkGenerationWorker.perform_async id: detail_id
    Rails.logger.info "Generate Share link enqueued. ID: #{detail_id}"
  end

  def refresh_caches(version)
    Rails.logger.info("Refreshing caches")
    past_versions(version.petition_plugin_detail_id)
  end

  def past_versions(id)
    petition_service.fetch_past_versions id, fresh: true
  rescue => e
    Rails.logger.info("Error fetching petition past versions: #{e.message} #{e.backtrace.join(" | ")}")
  end
end
