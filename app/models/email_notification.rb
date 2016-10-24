# == Schema Information
#
# Table name: email_notifications
#
#  id              :integer          not null, primary key
#  notification_id :integer
#  to_email        :string
#  from_email      :string
#  subject         :text
#  content         :text
#  sent_at         :datetime
#  deleted_at      :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class EmailNotification < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :notification

  validates_presence_of :notification, :to_email, :from_email, :subject, :content

  after_create :notify

  def notify
    # should send an e-mail containing the notification

    if Rails.env.development? or self.notification.target_user.is_a? User
      NotificationMailer.send_notification_email(self).deliver_now
      update_attribute(:sent_at, Time.now) unless sent_at?
    end
  end
end
