# == Schema Information
#
# Table name: session_tokens
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  token      :string
#  expire_at  :datetime
#  platform   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class SessionToken < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :platform

  before_create :set_token, :set_expiry_date

  # scope :valid_for, lambda { |plat| where('expire_at >= ? AND platform = ?', Time.now, plat) }
  #ran into a weird problem with this scope returning a WhereClause instead of a relation
  scope :valid_for, -> (plat) { self.where{ (expire_at >= Time.zone.now) & (platform.eq plat) } }

  private

  def set_token
    self.token = Devise.friendly_token
  end

  def set_expiry_date
    self.expire_at = Time.now + expiration_time
  end

  def expiration_time
    2.days
  end

end
