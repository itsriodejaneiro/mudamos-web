module PetitionPlugin
  class DetailVersionRepository
    include Repository

    def find_published_by_relation_id(relation_id)
      PetitionPlugin::DetailVersion
        .published
        .joins(:petition_plugin_detail)
        .where(petition_plugin_detail: { plugin_relation_id: relation_id })
        .first
    end
  end
end
