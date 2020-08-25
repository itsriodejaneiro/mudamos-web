class LaiPdfGenerationWorker
  include Shoryuken::Worker

  shoryuken_options queue: Rails.application.secrets.queues['lai_pdf_generation'], auto_delete: true

  attr_accessor :lai_repository
  attr_accessor :city_repository
  attr_accessor :s3
  attr_accessor :pdf_generator

  def initialize(
    lai_repository: LaiPdfRepository.new,
    city_repository: CityRepository.new,
    s3: AwsService::S3.new,
    pdf_generator: Pdf::LaiGenerator.new
  )
    @lai_repository = lai_repository
    @city_repository = city_repository
    @s3 = s3
    @pdf_generator = pdf_generator
  end

  def perform(sqs_msg, body)
    id = JSON.parse(body)['id']

    lai = lai_repository.find(id)

    return if lai.nil?

    lai_payload = lai.request_payload
    city = city_repository.find_best_match(lai_payload["city"], lai_payload["uf"])

    is_big_city = city.population > 10000

    pdf = pdf_generator.from_lai_request_payload(lai_payload, is_big_city)
    obj = s3.upload(Rails.application.secrets.buckets["lai_pdf"], "#{lai.pdf_id}.pdf", pdf, acl: "public-read")

    lai.pdf_url = obj.public_url
    lai.save!
  end

  def logger
    Rails.logger
  end
end
