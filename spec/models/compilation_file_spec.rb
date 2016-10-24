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

require 'rails_helper'

RSpec.describe CompilationFile, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
