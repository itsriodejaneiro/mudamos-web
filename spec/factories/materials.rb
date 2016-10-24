# == Schema Information
#
# Table name: materials
#
#  id                 :integer          not null, primary key
#  author             :string
#  title              :string
#  source             :string
#  publishing_date    :datetime
#  category           :string
#  external_link      :string
#  themes             :string
#  keywords           :string
#  description        :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  cycle_id           :integer
#  position           :integer
#  plugin_relation_id :integer
#

FactoryGirl.define do
  factory :material do
    author "Mudamos"
    title "MyString"
    source "wwww.mudamos.org"
    publishing_date "2015-10-22 16:12:11"
    external_link "wwww.mudamos.org"
    description "Description"


    ["Artigo", "Video", "Materia",
     "Nota Tecnica", "Entrevista", "Site",
     "Relatório", "Guia",
     "Cartilha", "Diretrizes",
     "Manifesto", "Lista de Topicos", "Noticia"].each do |type|

      factory "#{type.gsub(' ', "_").underscore}_material".to_sym do
        category type
      end

      after (:build) do |material|
        material.keywords = type
        material.themes = type
      end

    end
  end

end
