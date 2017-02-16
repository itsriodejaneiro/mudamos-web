class PetitionService

  attr_reader :mobile_service
  attr_reader :petition_repository

  def initialize(
    mobile_service: MobileApiService.new,
    petition_repository: PetitionPlugin::DetailRepository.new
  )
    @mobile_service = mobile_service
    @petition_repository = petition_repository
  end

  def fetch_petition_info(petition_id, fresh: false)
    cache_key = "mobile_petition_info:#{petition_id}"

    petition_info = Rails.cache.fetch(cache_key, force: fresh) do
      mobile_service.petition_info(petition_id)
    end
  end

  def fetch_petition_signers(petition_id, limit, fresh: false)
    cache_key = "mobile_petition_signers:#{petition_id}:limit:#{limit}"

    petition_signers = Rails.cache.fetch(cache_key, force: fresh) do
      petition = petition_repository.find_by_id!(petition_id)

      if petition.published_version.present?
        return mobile_service.petition_version_signers petition.published_version.id, limit 
      end
    end
  end

  def fetch_petition_signatures(petition_id, fresh: false)
    cache_key = "mobile_petition_signatures:#{petition_id}"

    Rails.cache.fetch(cache_key, force: fresh) do
      mobile_service.petition_signatures(petition_id)
    end
  end

  def fetch_petition_status(petition_sha, fresh: false)
    cache_key = "mobile_petition_status:#{petition_sha}"

    petition_status = Rails.cache.fetch(cache_key, force: fresh) do
      mobile_service.petition_status(petition_sha)
    end
  end
end
