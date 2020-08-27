class LaiPdfGenerationWorker
  include Shoryuken::Worker
  include IbgeHelper

  shoryuken_options queue: Rails.application.secrets.queues['lai_pdf_generation'], auto_delete: true

  attr_accessor :lai_repository
  attr_accessor :mailer
  attr_accessor :s3
  attr_accessor :pdf_generator

  def initialize(
    lai_repository: LaiPdfRepository.new,
    mailer: LaiPdfMailer,
    s3: AwsService::S3.new,
    pdf_generator: Pdf::LaiGenerator.new
  )
    @lai_repository = lai_repository
    @mailer = mailer
    @s3 = s3
    @pdf_generator = pdf_generator
  end

  def perform(sqs_msg, body)
    id = JSON.parse(body)['id']


    lai = lai_repository.find_by_id(id)
    return if lai.nil?

    lai_payload = lai.request_payload
    ibge_city = find_city_best_match(city: lai_payload["city"], uf: lai_payload["uf"])

    is_big_city = ibge_city["population"] > 10000

    pdf = pdf_generator.from_lai_request_payload(lai_payload, is_big_city)
    obj = s3.upload(Rails.application.secrets.buckets["lai_pdf"], "#{lai.pdf_id}.pdf", pdf, acl: "public-read")

    lai.pdf_url = obj.public_url
    lai.save!

    mailer.send_mail(lai.pdf_url, lai_payload).deliver_now
  end

  def logger
    Rails.logger
  end
end
