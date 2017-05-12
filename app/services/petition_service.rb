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

  PetitionInfo = Struct.new(
    :updated_at,
    :signatures_count,
    :blockchain_address,
    :initial_signatures_goal,
    :total_signatures_required,
    :current_signatures_goal,
  )
  def fetch_petition_info_with(petition:, fresh: false)
    cache_key = "mobile_petition_info:v2:#{petition.id}"

    info = Rails.cache.fetch(cache_key, force: fresh) do
      mobile_service.petition_info(petition.id)
    end

    current_signatures_goal = compute_current_signatures_goal(
      signatures_count: info.signatures_count,
      initial_signatures_goal: petition.initial_signatures_goal,
      total_signatures_required: petition.signatures_required
    )

    PetitionInfo.new(
      info.updated_at,
      info.signatures_count,
      info.blockchain_address,
      petition.initial_signatures_goal,
      petition.signatures_required,
      current_signatures_goal
    )
  end

  def fetch_petition_info(petition_id, fresh: false)
    petition = petition_repository.find_by_id!(petition_id)
    fetch_petition_info_with petition: petition, fresh: fresh
  end

  def fetch_petition_signers(petition_id, limit, fresh: false)
    cache_key = "mobile_petition_signers:#{petition_id}:limit:#{limit}"

    Rails.cache.fetch(cache_key, force: fresh) do
      petition = petition_repository.find_by_id!(petition_id)

      if petition.published_version.present?
        return mobile_service.petition_version_signers petition.published_version.id, limit
      end
    end
  end

  def fetch_petition_status(petition_sha, fresh: false)
    cache_key = "mobile_petition_status:#{petition_sha}"

    Rails.cache.fetch(cache_key, force: fresh) do
      mobile_service.petition_status(petition_sha)
    end
  end

  def fetch_petition_signatures(petition_id, fresh: false)
    cache_key = "mobile_petition_signatures:#{petition_id}"

    Rails.cache.fetch(cache_key, force: fresh) do
      mobile_service.petition_signatures(petition_id)
    end
  end

  def fetch_past_versions(petition_id, fresh: false)
    cache_key = "mobile_petition_past_versions:#{petition_id}"

    Rails.cache.fetch(cache_key, force: fresh) do
      begin
        mobile_service.petition_versions(petition_id)
      rescue => e
        Rails.logger.info("Error fetching petition past versions: #{e.message} #{e.backtrace.join(" | ")}")
        Array.new
      end
    end
  end

  # Increases the current goal by the given ratio
  # Clamps the goal to a 1_000 multiplier
  def compute_current_signatures_goal(ratio: 1.25, signatures_count:, initial_signatures_goal:, total_signatures_required:)
    signatures_count ||= 0
    current_goal = initial_signatures_goal

    loop do
      if signatures_count >= current_goal
        current_goal = (current_goal * ratio).round
      else
        # Normalize #000
        adjust = current_goal % 1000
        adjust = adjust > 0 ? 1000 - adjust : adjust
        current_goal = current_goal + adjust

        return [current_goal, total_signatures_required].min
      end
    end
  end
end
