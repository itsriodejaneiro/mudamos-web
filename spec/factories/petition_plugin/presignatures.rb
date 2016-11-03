FactoryGirl.define do
  factory :petition_plugin_presignature, class: 'PetitionPlugin::Presignature' do
    user
    plugin_relation do
      cycle = CycleTestHelper.create_cycle_with_phase(phases: [{ plugin_type: :petition }])
      cycle.plugin_relations.first
    end
  end
end
