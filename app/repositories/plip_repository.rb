class PlipRepository
  include Repository

  def all_initiated(page: 1, limit: 10)

    phases = Phase
      .initiated
      .includes(:plugin_relation)
      .includes(:cycle)
      .joins(plugin_relation: :plugin)
      .joins(plugin_relation: :petition_detail)
      .joins(plugin_relation: { petition_detail: :petition_detail_versions })
      .where(plugin_relation: { plugin: { plugin_type: PluginTypeRepository::ALL_TYPES[:petition] }})
      .where.not(petition_plugin_details: { id: nil })
      .where.not(petition_plugin_detail_versions: { id: nil })
      .where(petition_plugin_detail_versions: { published: true })
      .page(page)
      .per(limit)

    has_next = !phases.last_page?

    plips = phases.map do |phase|
      petition = phase.plugin_relation.petition_detail

      Plip.new id: petition.published_version.id,
               document_url: petition.published_version.document_url,
               content: petition.published_version.body,
               phase: phase,
               presentation: petition.presentation,
               signatures_required: petition.signatures_required,
               call_to_action: petition.call_to_action
    end

    Pagination.new items: plips, page: page, limit: limit, has_next: has_next
  end
end
