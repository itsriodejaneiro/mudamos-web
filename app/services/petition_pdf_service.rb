class PetitionPdfService

  attr_reader :s3

  def initialize(s3: AwsService::S3.new)
    @s3 = s3
  end

  Result = Struct.new(:document_name, :sha, :document_url)

  def generate(version)
    pdf = Kramdown::Document.new(version.body).to_pdf

    cycle = version.petition_plugin_detail.plugin_relation.related.cycle
    phase = version.petition_plugin_detail.plugin_relation.related

    document_name = "#{cycle.slug}-peticao-#{phase.id}-#{version.id}.pdf"

    obj = s3.upload(Rails.application.secrets.buckets['petition_pdf'], document_name, pdf, acl: 'public-read')

    Result.new document_name, content_sha(pdf), obj.public_url
  end

  private

  def content_sha(content)
    Digest::SHA256.hexdigest content
  end
end
