class PetitionPdfGenerationWorker
  include Shoryuken::Worker
  shoryuken_options queue: Rails.application.secrets.queues['petition_pdf_generation'], auto_delete: true

  attr_reader :petition_pdf_service

  def initialize(petition_pdf_service: PetitionPdfService.new)
    @petition_pdf_service = petition_pdf_service
  end

  def perform(sqs_msg, body)
    petition_detail_version_id = JSON.parse(body)['id']
    puts "Processing plugin detail version: #{petition_detail_version_id}"

    version = PetitionPlugin::DetailVersion.find petition_detail_version_id

    document_url = petition_pdf_service.generate(version) 
    version.update published: true, document_url: document_url
  end
end
