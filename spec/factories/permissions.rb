# == Schema Information
#
# Table name: permissions
#
#  id               :integer          not null, primary key
#  target_id        :integer
#  target_type      :string
#  can_manage_users :boolean
#  can_view         :boolean
#  can_create       :boolean
#  can_update       :boolean
#  can_delete       :boolean
#  deleted_at       :datetime
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

FactoryGirl.define do
  factory :permission do
    target_id 1
    target_type "MyString"
    can_manage_users false
    can_view false
    can_create false
    can_update false
    can_delete false
  end

end
