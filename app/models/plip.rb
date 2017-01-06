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

  # @!attribute [rw] presentation
  #   @return [String]
  attr_accessor :presentation
 
  # @!attribute [rw] signatures_required
  #   @return [String]
  attr_accessor :signatures_required
 
  # @!attribute [rw] call_to_action
  #   @return [String]
  attr_accessor :call_to_action

  # @param document_url [String]
  # @param content [String]
  # @param phase [Phase]
  def initialize(document_url:, content:, phase:, presentation:, signatures_required:, call_to_action:)
    @document_url = document_url
    @content = content
    @phase = phase
    @presentation = presentation
    @signatures_required = signatures_required
    @call_to_action = call_to_action
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
