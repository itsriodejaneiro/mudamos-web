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

FactoryGirl.define do
  factory :social_link do
    sequence(:provider) { |n| "Social Media #{n}" }
    sequence(:link)     { |n| "Link #{n}"}
    icon_class "class"
    description "Visit us!!"
    sequence(:cycle) {|n| FactoryGirl.create(:cycle)}
  end

end
