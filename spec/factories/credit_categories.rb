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

FactoryGirl.define do
  factory :credit_category do
    name "MyString"
deleted_at "2016-01-13 14:37:02"
  end

end
