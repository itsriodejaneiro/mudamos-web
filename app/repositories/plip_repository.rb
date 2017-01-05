class PlipRepository
  include Repository

  def all_initiated(page: 1, limit: 10)
    phases = Phase
      .initiated
      .includes(:plugin_relation)
      .includes(:cycle)
      .joins(plugin_relation: :plugin)
      .joins(plugin_relation: :petition_information)
      .where(plugin_relation: { plugin: { plugin_type: PluginTypeRepository::ALL_TYPES[:petition] }})
      .where.not(petition_plugin_information: { id: nil })
      .page(page)
      .per(limit)

    has_next = !phases.last_page?

    plips = phases.map do |phase|
      petition = phase.plugin_relation.petition_information

      Plip.new document_url: petition.document_url,
               content: petition.body,
               phase: phase
    end

    Pagination.new items: plips, page: page, limit: limit, has_next: has_next
  end
end
