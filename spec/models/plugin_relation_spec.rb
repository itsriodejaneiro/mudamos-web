# == Schema Information
#
# Table name: plugin_relations
#
#  id           :integer          not null, primary key
#  related_id   :integer
#  related_type :string
#  plugin_id    :integer
#  is_readonly  :boolean
#  read_only_at :datetime
#  deleted_at   :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  slug         :string
#

require 'rails_helper'

RSpec.describe PluginRelation, type: :model do

  [:phase, :cycle].each do |rel|
    ['blog', 'discussion', 'compilation', 'static_page'].each do |type|
      factory = "#{rel}_#{type}_plugin_relation"
      subject { FactoryGirl.build_stubbed(factory .to_sym) }

      include_examples 'paranoia' , factory

      [:permissions, :subjects].each do |attr|
        it "should have many #{attr}s" do
          should have_many(attr).dependent(:destroy)
        end
      end

      [:related, :plugin].each do |attr|
        it "should belong to #{attr}" do
          should belong_to attr
        end

        it "should validate the presence of #{attr}" do
          should validate_presence_of attr
        end
      end
    end
  end





end
