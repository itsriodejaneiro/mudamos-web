class Plip
  extend Forwardable

  def_delegators :detail, :published_version,
                          :presentation,
                          :call_to_action,
                          :video_id,
                          :uf,
                          :city
  def_delegators :published_version, :id, :document_url
  def_delegators :phase, :cycle

  def_delegators :petition_info, :total_signatures_required,
                                 :initial_signatures_goal

  ScopeCoverage = Struct.new(:scope, :uf, :city)

  # @!attribute [rw] detail
  #   @return [PetitionPlugin::Detail]
  attr_accessor :detail

  # @!attribute [rw] phase
  #   @return [Phase]
  attr_accessor :phase

  # @!attribute [rw] plip_url
  #   @return [String]
  attr_accessor :plip_url

  # @!attribute [rw] petition_service
  #   @return [PetitionService]
  attr_accessor :petition_service

  def initialize(detail:, phase:, plip_url:, petition_service: PetitionService.new)
    @detail = detail
    @phase = phase
    @plip_url = plip_url
    @petition_service = petition_service
  end

  def detail_id
    detail.id
  end

  def content
    published_version.body
  end

  def scope_coverage
    ScopeCoverage.new(detail.scope_coverage, detail.uf, detail.city)
  end

  def signatures_required
    petition_info.current_signatures_goal
  end

  def petition_info
    @petition_info ||= petition_service.fetch_petition_info_with(petition: detail)
  end

  def marshal_dump
    [detail, phase, plip_url]
  end

  def marshal_load(args)
    attrs = %w(detail phase plip_url).zip args
    initialize(**Hash[attrs].deep_symbolize_keys)
  end
end
