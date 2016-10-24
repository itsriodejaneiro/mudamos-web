# == Schema Information
#
# Table name: dislikes
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  comment_id :integer
#  deleted_at :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Dislike < ActiveRecord::Base
  include Toggleable
  include ToggleableWithNotification
end
