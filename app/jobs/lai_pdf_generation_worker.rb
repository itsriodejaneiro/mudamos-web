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

    return if lai.nil? || lai.email_sent_at
    return send_email(lai: lai) if lai.pdf_url

    lai_payload = lai.request_payload
    ibge_city = get_city(lai)
    is_big_city = ibge_city["population"].to_i > 10000

    pdf = pdf_generator.generate(
      city_name: ibge_city["name"],
      is_big_city: is_big_city,
      justification: lai_payload["justification"]
    )
    obj = s3.upload(Rails.application.secrets.buckets["lai_pdf"], "#{lai.pdf_id}.pdf", pdf, acl: "public-read")

    lai.pdf_url = obj.public_url
    lai.save!

    send_email(lai: lai, city_name: ibge_city["name"])
  end

  def send_email(lai:, city_name: nil)
    city_name = get_city(lai)["name"] if city_name.nil?
    lai_payload = lai.request_payload

    mailer.send_mail(
      city_name: city_name,
      email: lai_payload["email"],
      name: lai_payload["name"],
      pdf_url: lai.pdf_url
    ).deliver_now

    lai.email_sent_at = Time.current
    lai.save!
  end

  def get_city(lai)
    lai_payload = lai.request_payload
    ibge_city = find_city_best_match(city: lai_payload["city"], uf: lai_payload["uf"])
  end
end
