# == Schema Information
#
# Table name: internal_notifications
#
#  id              :integer          not null, primary key
#  notification_id :integer
#  read_at         :datetime
#  deleted_at      :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class InternalNotification < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :notification

  validates_presence_of :notification

  scope :unread, -> { where(read_at: nil) }

  def notify
    # update_attribute(:read_at, Time.now) unless read_at?
  end
end
