# == Schema Information
#
# Table name: plugins
#
#  id              :integer          not null, primary key
#  name            :string
#  plugin_type     :string
#  can_be_readonly :boolean
#  deleted_at      :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  icon_class      :string
#

require 'rails_helper'

RSpec.describe Plugin, type: :model do
  include_examples 'paranoia'

  [:name, :plugin_type].each do |attr|
   it "should validate presence of #{attr}" do
    should validate_presence_of attr
   end
  end

  # RELATIONS
  [:plugin_relations, :permissions].each do |attr|
    it "should have many #{attr}" do
      should have_many(attr).dependent(:destroy)
    end
  end
end
