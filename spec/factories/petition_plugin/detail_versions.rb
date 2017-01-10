FactoryGirl.define do
  factory :petition_plugin_detail_version, class: 'PetitionPlugin::DetailVersion' do
    body '== Projeto de lei'
    document_url 'http://projeto.bla'
  end
end
