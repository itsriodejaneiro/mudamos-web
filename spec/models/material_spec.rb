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

require 'rails_helper'

RSpec.describe Material, type: :model do
  ["Artigo", "Video", "Materia",
   "Nota Tecnica", "Entrevista", "Site",
   "Relatório", "Guia",
   "Cartilha", "Diretrizes",
   "Manifesto", "Lista de Topicos", "Noticia"].each do |type|
    factory = "#{type.gsub(' ', "_").underscore}_material".to_sym
    describe factory do
      subject { FactoryGirl.build_stubbed(factory) }
      let(:material) { FactoryGirl.build(factory) }

      # PRESENCE
      [:title, :external_link, :cycle].each do |attr|
        it  "should validate the presence of #{attr} " do
          should validate_presence_of attr
        end
      end

      [:keywords, :themes].each do |method|
        it "should respond to #{method}" do
          should respond_to method
        end
        unless method == :tag_list
          ['Simple Value', 'Array;of;values'].each do |val|
            it "calling #{method}= #{val} should increment by #{val.split(';').count}" do
              expect{ material.send("#{method}=",val) }.to change{ material.send("#{method}").count }.by(val.split(";").count)
            end
          end
        end
      end
    end
  end

  describe "The class Material" do
    subject { Material }
    it 'Should respond_to the class method tag_list' do
      should respond_to :tag_list
    end
  end

end
