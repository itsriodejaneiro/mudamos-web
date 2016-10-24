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

FactoryGirl.define do
  factory :credit do
    credit_category nil
name "MyString"
content "MyText"
deleted_at "2016-01-14 10:48:52"
  end

end
