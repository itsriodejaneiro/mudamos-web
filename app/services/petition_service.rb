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
      petition = petition_repository.find_by_id!(petition_id)
      # For now national cause won't list the pdf signatures
      return [] if petition.national_cause?

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
    return initial_signatures_goal if signatures_count.zero?

    current_goal = initial_signatures_goal

    clamp = -> signature { [signature, total_signatures_required].min }

    # Double the signature target until the target is greater than the current signature count
    #
    # @example
    #   signatures_count = 58
    #   initial_signatures_goal = 15
    #   initial_signatures_goal * 2 ^ ceil(ln(signatures_count / initial_signatures_goal) / ln(2)) => 60
    #
    #   The target would try 15, 30 and finally 60
    #
    # @see https://www.wolframalpha.com/input/?i=x+*+2+%5E+ceil(ln(y+%2F+x)+%2F+ln(2)) for a visual equation
    #
    # A loop representaion of this equation resolving equal terms is
    # @example
    #   loop do
    #     if signatures_count >= current_goal
    #       current_goal *= 2
    #     else
    #       return [current_goal, total_signatures_required].min
    #     end
    #   end
    low_method = -> {
      target = initial_signatures_goal * (2 ** (Math.log(signatures_count / initial_signatures_goal.to_f) / Math.log(2)).ceil)
      target = target * 2 if target == signatures_count
      clamp.call target.zero? ? initial_signatures_goal : target
    }

    high_method = -> {
      loop do
        if signatures_count >= current_goal
          current_goal = (current_goal * ratio).round
        else
          # Normalize #000
          adjust = current_goal % 1000
          adjust = adjust > 0 ? 1000 - adjust : adjust
          current_goal = current_goal + adjust

          return clamp.call current_goal
        end
      end
    }

    if current_goal < 1_000
      low_method.call
    else
      high_method.call
    end
  end
end
