# == Schema Information
#
# Table name: alias_names
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :alias_name do
    sequence(:name) { |n| "Nome Alias #{n}" }
  end

end
