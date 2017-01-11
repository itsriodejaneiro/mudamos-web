class PetitionPdfGenerationWorker
  include Shoryuken::Worker
  shoryuken_options queue: Rails.application.secrets.queues['petition_pdf_generation'], auto_delete: true

  attr_reader :petition_pdf_service
  attr_reader :repository

  def initialize(petition_pdf_service: PetitionPdfService.new, repository: PetitionPlugin::DetailVersionRepository.new)
    @petition_pdf_service = petition_pdf_service
    @repository = repository
  end

  def perform(sqs_msg, body)
    petition_detail_version_id = JSON.parse(body)['id']
    Rails.logger.info "Processing plugin detail version: #{petition_detail_version_id}"

    version = repository.find_by_id! petition_detail_version_id

    document_url = petition_pdf_service.generate(version) 
    version.update published: true, document_url: document_url
  end
end
