
FactoryGirl.define do
  factory :petition_plugin_detail, class: 'PetitionPlugin::Detail' do
    plugin_relation do
      cycle = CycleTestHelper.create_cycle_with_phase(phases: [{ plugin_type: :petition }])
      cycle.plugin_relations.first
    end
    call_to_action 'Assine o projeto'
    signatures_required 4000
    presentation 'Apresentação'
    petition_detail_versions { [ FactoryGirl.build(:petition_plugin_detail_version) ] }
  end
end
