# == Schema Information
#
# Table name: reports
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  comment_id :integer
#  deleted_at :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Report < ActiveRecord::Base
  include Toggleable
  include ToggleableWithNotification

  after_create :notify_admin

  def notify_admin
    AdminUser.all.each do |admin|
      send_notification(admin)
    end
  end
end
