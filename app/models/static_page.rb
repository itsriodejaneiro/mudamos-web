# == Schema Information
#
# Table name: static_pages
#
#  id             :integer          not null, primary key
#  name           :string
#  title          :string
#  slug           :string
#  cycle_id       :integer
#  content        :text
#  show_on_footer :boolean          default(TRUE)
#  show_on_header :boolean          default(FALSE)
#  deleted_at     :datetime
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class StaticPage < ActiveRecord::Base
  acts_as_paranoid
  
  extend FriendlyId
  friendly_id :name

  belongs_to :cycle

  validates_presence_of :name, :content
end
