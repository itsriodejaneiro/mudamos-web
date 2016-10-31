class PlipRepository
  include Repository

  attr_accessor :petition_repository

  def initialize(petition_repository: PetitionRepository.new)
    @petition_repository = petition_repository
  end

  def all_initiated(page: 1, limit: 10)
    phases = Phase
      .initiated
      .includes(:plugin_relation)
      .includes(:cycle)
      .joins(plugin_relation: :plugin)
      .where(plugin_relation: { plugin: { plugin_type: PluginTypeRepository::ALL_TYPES[:petition] }})
      .page(page)
      .per(limit)

    has_next = !phases.last_page?

    petition = petition_repository.mock
    plips = phases.map do |phase|
      Plip.new document_url: petition.document_url,
               content: petition.body,
               phase: phase
    end

    Pagination.new items: plips, page: page, limit: limit, has_next: has_next
  end
end
