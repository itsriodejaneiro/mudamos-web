class PetitionPdfGenerationWorker
  include Shoryuken::Worker
  shoryuken_options queue: Rails.application.secrets.queues['petition_pdf_generation']

  def perform(sqs_msg, body)
    petition_detail_version_id = JSON.parse(body)['id']


    puts petition_detail_version_id

    petition_detail_version = PetitionPlugin::DetailVersion.find petition_detail_version_id
    pdf = Kramdown::Document.new(petition_detail_version.body).to_pdf

    s3 = Aws::S3::Resource.new
    obj = s3.bucket(Rails.application.secrets.buckets['petition_pdf']).object("#{petition_detail_version_id}.pdf")
    metadata = obj.put(body: pdf)

    document_url = "teste"#metadata.url
    petition_detail_version.update published: true, document_url: document_url
  end
end
