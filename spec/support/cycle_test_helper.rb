module CycleTestHelper
  # Creates a cycle with the given phases
  # @param phases [Array<Hash>] the cycle phases
  #   @option [Symbol] :plugin_type the plugin type
  #   @option [Symbol] :attrs custom phase attributes
  #
  # @return [Cycle]
  #
  # @example Default behaviour
  #   create_cycle_with_phase #=> cycle # with a report phase
  #
  # @example a discussion phase
  #   create_cycle_with_phase phases: [{ plugin_type: :discussion }]
  #
  # @example custom phase attributes
  #   create_cycle_with_phase phases: [{ plugin_type: :report, attrs: { initial_date: 1.day.from_now }]
  def create_cycle_with_phase(phases: [{ plugin_type: :report }])
    cycle = FactoryGirl.build(:cycle)

    phases = phases.map do |phase_attrs|
      plugin = FactoryGirl.create(:plugin, phase_attrs[:plugin_type])
      plugin_relation = FactoryGirl.build(:base_plugin_relation, plugin: plugin)
      
      if phase_attrs[:with_petition_information]
        plugin_relation.petition_detail = FactoryGirl.build(:petition_plugin_detail, plugin_relation: plugin_relation)
      end

      phase = FactoryGirl.build(:phase, cycle: cycle, plugin_relation: plugin_relation)
      phase.attributes = phase_attrs[:attrs] || {}

      plugin_relation.related = phase
      phase
    end

    cycle.phases = phases
    cycle.tap(&:save!)
  end

  module_function :create_cycle_with_phase
end

RSpec.configure do |config|
  config.include CycleTestHelper
end
