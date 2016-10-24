# == Schema Information
#
# Table name: vocabularies
#
#  id                 :integer          not null, primary key
#  cycle_id           :integer
#  title              :string
#  first_letter       :string
#  description        :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  plugin_relation_id :integer
#

FactoryGirl.define do
  factory :vocabulary do
    cycle nil
    title "MyString"
    first_letter "MyString"
    description "MyText"
  end

end
