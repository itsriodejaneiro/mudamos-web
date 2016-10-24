# == Schema Information
#
# Table name: omniauth_identities
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  provider   :string
#  uid        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class OmniauthIdentity < ActiveRecord::Base

  belongs_to :user
  validates_presence_of :uid, :provider
  validates_uniqueness_of :uid, scope: :provider

  def self.find_for_oauth auth
    find_or_initialize_by(uid: auth['uid'], provider: auth['provider'])
  end

end
