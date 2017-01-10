class PetitionPdfService
  def generate(version)
    pdf = Kramdown::Document.new(version.body).to_pdf

    cycle = version.petition_plugin_detail.plugin_relation.related.cycle
    phase = version.petition_plugin_detail.plugin_relation.related

    document_name = "#{cycle.subdomain}-peticao-#{phase.id}-#{version.id}.pdf"

    s3 = Aws::S3::Resource.new
    obj = s3.bucket(Rails.application.secrets.buckets['petition_pdf']).object(document_name)
    obj.put(body: pdf, acl: 'public-read')

    obj.public_url
  end
end
