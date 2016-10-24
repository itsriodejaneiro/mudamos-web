# == Schema Information
#
# Table name: credits
#
#  id                 :integer          not null, primary key
#  credit_category_id :integer
#  name               :string
#  content            :text
#  url                :string
#  deleted_at         :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class Credit < ActiveRecord::Base
  belongs_to :credit_category

  validates_presence_of :credit_category, :name, :content
end
