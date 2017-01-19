class PetitionPublisherWorker
  include Shoryuken::Worker
  shoryuken_options queue: Rails.application.secrets.queues['petition_publisher'], auto_delete: true

  attr_reader :repository

  def initialize(repository: PetitionPlugin::DetailVersionRepository.new)
    @repository = repository
  end

  def perform(sqs_msg, body)
    petition_detail_version_id = JSON.parse(body)['id']

    version = repository.find_by_id petition_detail_version_id

    if version
      version.update published: true
      Rails.logger.info "Version published #{petition_detail_version_id}"
    else
      Rails.logger.warn "Version not found #{petition_detail_version_id}"
    end
  end
end
