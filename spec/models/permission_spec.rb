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

require 'rails_helper'

RSpec.describe Permission, type: :model do
  include_examples 'paranoia'
end
