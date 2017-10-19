class PlipRepository
  include Repository
  include UserInput

  def current_plip
    plips = all_initiated(page: 1, limit: 1).items
    plips.last
  end

  def all_initiated(filters: {}, page: 1, limit: 10)
    default_filters = {
      cause: false,
    }
    filters = (filters || {}).reverse_merge(default_filters)
    cause = bool(filters[:cause])
    uf = filters[:uf]
    city_id = filters[:city_id]
    city_id = nil if cause

    # Backwards compatibility
    is_nationwide_search = uf.blank? && city_id.blank? && filters[:scope].blank?
    limit = (limit || 10).to_i
    limit = [limit, 100].min

    filtered_phases = Phase
      .initiated
      .select("DISTINCT phases.id, DISTINCT phases.initial_date")
      .includes(:plugin_relation)
      .includes(:cycle)
      .joins(plugin_relation: :plugin)
      .includes(plugin_relation: :petition_detail)
      .includes(plugin_relation: { petition_detail: %i(petition_detail_versions city) })
      .where(plugin_relation: { plugin: { plugin_type: PluginTypeRepository::ALL_TYPES[:petition] }})
      .where.not(petition_plugin_details: { id: nil })
      .where.not(petition_plugin_detail_versions: { id: nil })
      .where(petition_plugin_detail_versions: { published: true })


    scope = if is_nationwide_search
              PetitionPlugin::Detail::NATIONWIDE_SCOPE
            elsif PetitionPlugin::Detail::SCOPE_COVERAGES.include?(filters[:scope])
              filters[:scope]
            end

    filtered_phases = filtered_phases.where(petition_plugin_details: { uf: uf }) if uf.present?
    filtered_phases = filtered_phases.where(petition_plugin_details: { city_id: city_id }) if city_id.present?

    if !scope && !cause
      statements = Hash[*PetitionPlugin::Detail::SCOPE_COVERAGES.map { |coverage| [coverage, coverage] }.flatten].symbolize_keys
      filtered_phases = filtered_phases.where(<<-SQL, statements)
        petition_plugin_details.scope_coverage = :nationwide
        OR petition_plugin_details.scope_coverage = :statewide
        OR (petition_plugin_details.scope_coverage = :citywide AND petition_plugin_details.city_id IS NOT NULL)
      SQL
    end

    filtered_phases = filtered_phases.where(petition_plugin_details: { scope_coverage: scope }) if scope

    if scope === PetitionPlugin::Detail::CITYWIDE_SCOPE
      if !cause
        filtered_phases = filtered_phases.where.not(petition_plugin_details: { city_id: nil })
      else
        filtered_phases = filtered_phases.where(petition_plugin_details: { city_id: nil })
      end
    end

    phases =
      Phase.where(id: filtered_phases.pluck(:id))
        .includes(:cycle)
        .includes(plugin_relation: { petition_detail: %i(petition_detail_versions city) })
        .order("initial_date DESC")
        .page(page)
        .per(limit)

    has_next = !phases.last_page?

    plips = phases.map do |phase|
      petition = phase.plugin_relation.petition_detail

      Plip.new detail: petition,
               phase: phase,
               plip_url: generate_plip_url(phase)
    end

    Pagination.new items: plips, page: page, limit: limit, has_next: has_next
  end

  private

  def generate_plip_url(phase)
    Rails.application.routes.url_helpers.cycle_plugin_relation_url(
      phase.cycle,
      phase.plugin_relation
    )
  end
end
