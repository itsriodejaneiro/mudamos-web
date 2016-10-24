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

class Permission < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :target, polymorphic: true
  belongs_to :cycle
  belongs_to :phase
  belongs_to :plugin_relation
  belongs_to :plugin
  #TODO
  #has_many :admin_profile_permissions
end
