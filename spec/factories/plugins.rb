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

FactoryGirl.define do
  factory :plugin do
    name "MyString"
    plugin_type "MyString"
    can_be_readonly false
    icon_class 'discussion'
  end

end
