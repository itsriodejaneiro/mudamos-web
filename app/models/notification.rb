# == Schema Information
#
# Table name: notifications
#
#  id                 :integer          not null, primary key
#  target_user_id     :integer
#  target_user_type   :string
#  target_object_id   :integer
#  target_object_type :string
#  title              :text
#  description        :text
#  view_url           :string
#  deleted_at         :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  picture_url        :string
#

class Notification < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :target_user, polymorphic: true
  belongs_to :target_object, polymorphic: true

  has_many :push_notifications, dependent: :destroy
  has_many :internal_notifications, dependent: :destroy
  has_many :email_notifications, dependent: :destroy

  validates_presence_of :target_object, :target_user, :title, :description, :view_url

  def picture_url
    super || User.anonymous_picture_url
  end

  def all_attributes
    super + [:target_user, :target_object]
  end

end


