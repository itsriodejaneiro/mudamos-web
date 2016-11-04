class Plip
  # @!attribute [rw] document_url
  #   @return [String]
  attr_accessor :document_url

  # @!attribute [rw] content
  #   @return [String]
  attr_accessor :content

  # @!attribute [rw] phase
  #   @return [Phase]
  attr_accessor :phase

  # @param document_url [String]
  # @param content [String]
  # @param phase [Phase]
  def initialize(document_url:, content:, phase:)
    @document_url = document_url
    @content = content
    @phase = phase
  end

  # @return [Cycle]
  def cycle
    phase.cycle
  end

  # Mocked plip id.
  # This represents the plip version
  def id
    1
  end
end
