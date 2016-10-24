# == Schema Information
#
# Table name: push_notifications
#
#  id              :integer          not null, primary key
#  notification_id :integer
#  sent_at         :datetime
#  deleted_at      :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class PushNotification < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :notification
  validates_presence_of :notification

  def notify
    # should send a push notification containing the notification
    update_attribute(:sent_at, Time.now) unless sent_at?
  end
end

