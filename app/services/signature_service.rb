class SignatureService

  attr_reader :mobile_service

  def initialize(mobile_service: MobileApiService.new)
    @mobile_service = mobile_service
  end

  def fetch_signature_status(signature, fresh: false)
    cache_key = "mobile_signature_status:#{signature}"

    Rails.cache.fetch(cache_key, force: fresh) do
      mobile_service.signature_status(signature)
    end
  end
end
