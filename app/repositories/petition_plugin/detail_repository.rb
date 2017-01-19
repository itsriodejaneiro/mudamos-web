module PetitionPlugin
  class DetailRepository
    include Repository

    def past_versions_desc(detail)
      detail.past_versions.order(created_at: :desc)
    end
  end
end
