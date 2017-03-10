module PetitionPlugin
  class DetailRepository
    include Repository

    def past_versions_desc(detail_id)
      find_by_id!(detail_id).past_versions.order(created_at: :desc)
    end
  end
end
