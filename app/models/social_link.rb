# == Schema Information
#
# Table name: social_links
#
#  id          :integer          not null, primary key
#  provider    :string
#  link        :string
#  icon_class  :string
#  description :text
#  cycle_id    :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  name        :string
#

class SocialLink < ActiveRecord::Base
  belongs_to :cycle
  has_many :grid_highlights, as: :target_object

  validates_uniqueness_of :provider, scope: :cycle_id

  validates_presence_of :provider, :link, :icon_class, :description

  def self.icons
    [
      'icon-email',
      'icon-twitter',
      'icon-facebook',
      'icon-google',
      'icon-linkedin',
      'icon-youtube',
      'icon-instagram',
      'icon-tumblr',
      'icon-pinterest'
    ]
  end
end
