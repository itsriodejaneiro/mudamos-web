# == Schema Information
#
# Table name: alias_names
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class AliasName < ActiveRecord::Base
  default_scope { order('RANDOM()') }

  scope :options, -> { limit(10) }

  validates_presence_of :name
  validates_uniqueness_of :name
end
