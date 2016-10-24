# == Schema Information
#
# Table name: compilation_files
#
#  id                 :integer          not null, primary key
#  plugin_relation_id :integer
#  title1             :string           default("Perfil de Cadastrados na Plataforma")
#  title2             :string           default("Adesão dos Participantes aos Assuntos")
#  title3             :string           default("Participação de Anônimos X Identificados")
#  file_file_name     :string
#  file_content_type  :string
#  file_file_size     :integer
#  file_updated_at    :datetime
#  deleted_at         :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

FactoryGirl.define do
  factory :compilation_file do
    plugin_relation nil
file ""
deleted_at "2016-01-22 14:29:19"
  end

end
