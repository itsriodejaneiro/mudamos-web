FactoryGirl.define do
  factory :petition_plugin_information, class: 'PetitionPlugin::Information' do
    plugin_relation do
      cycle = CycleTestHelper.create_cycle_with_phase(phases: [{ plugin_type: :petition }])
      cycle.plugin_relations.first
    end
    call_to_action 'Assine o projeto'
    signatures_required 4000
    presentation 'Apresentação'
    body '== Projeto de lei'
    document_url 'http://projeto.bla'
  end
end
