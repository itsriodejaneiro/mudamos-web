class PlipRepository
  include Repository
  include UserInput

  def current_plip
    plips = all_initiated(page: 1, limit: 1).items
    plips.last
  end

  def find_plip_by_id(id)
    detail = PetitionPlugin::Detail
      .where(id: id)
      .includes(plugin_relation: { related: %i(cycle plugin_relation) }).first

    return if !detail || !detail.published_version

    phase = detail.plugin_relation.related

    Plip.new detail: detail,
             phase: phase,
             plip_url: generate_plip_url(phase)
  end

  def find_plip_by_slug(slug)
    phase = Phase
        .includes(:cycle)
        .where(cycle: Cycle.find(slug))
        .includes(:plugin_relation)
        .joins(plugin_relation: :plugin)
        .includes(plugin_relation: :petition_detail)
        .includes(plugin_relation: { petition_detail: %i(petition_detail_versions city) })
        .where(plugin_relation: { plugin: { plugin_type: PluginTypeRepository::ALL_TYPES[:petition] }})
        .first

    return unless phase

    petition = phase.plugin_relation.petition_detail

    Plip.new detail: petition,
             phase: phase,
             plip_url: generate_plip_url(phase)
  end

  def all_initiated(filters: {}, page: 1, limit: 10)
    default_filters = {
      include_causes: false,
    }
    filters = (filters || {}).reverse_merge(default_filters)
    causes_only = filters[:scope] === "causes"
    include_causes = bool(filters[:include_causes]) || causes_only
    uf = filters[:uf]
    uf = nil if include_causes
    city_id = filters[:city_id]
    city_id = nil if include_causes

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

    if causes_only
      statements = Hash[*PetitionPlugin::Detail::SCOPE_COVERAGES.map { |coverage| [coverage, coverage] }.flatten].symbolize_keys
      filtered_phases = filtered_phases.where(<<-SQL, statements)
        (
          petition_plugin_details.scope_coverage = :statewide
          AND coalesce(petition_plugin_details.uf, '') = ''
        )
        OR (
          petition_plugin_details.scope_coverage = :citywide
          AND petition_plugin_details.city_id IS NULL
        )
      SQL
    elsif !include_causes && !scope
      statements = Hash[*PetitionPlugin::Detail::SCOPE_COVERAGES.map { |coverage| [coverage, coverage] }.flatten].symbolize_keys

      filtered_phases = filtered_phases.where(<<-SQL, statements)
        petition_plugin_details.scope_coverage = :nationwide
        OR (
          petition_plugin_details.scope_coverage = :statewide
          AND coalesce(petition_plugin_details.uf, '') <> ''
        )
        OR (petition_plugin_details.scope_coverage = :citywide AND petition_plugin_details.city_id IS NOT NULL)
      SQL
    elsif !include_causes && scope != PetitionPlugin::Detail::NATIONWIDE_SCOPE
      statements = { scope_coverage: scope }
      filtered_phases = filtered_phases.where(<<-SQL, statements)
        petition_plugin_details.scope_coverage = :scope_coverage
        AND (
          coalesce(petition_plugin_details.uf, '') <> ''
          OR petition_plugin_details.city_id IS NOT NULL
        )
      SQL
    elsif scope
      filtered_phases = filtered_phases.where(petition_plugin_details: { scope_coverage: scope })
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
