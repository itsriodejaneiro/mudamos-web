# == Schema Information
#
# Table name: credit_categories
#
#  id         :integer          not null, primary key
#  name       :string
#  position   :integer
#  deleted_at :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class CreditCategory < ActiveRecord::Base
  acts_as_paranoid

  default_scope { order('position ASC') }

  has_many :credits, dependent: :destroy

  validates_presence_of :name
end
