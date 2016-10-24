# == Schema Information
#
# Table name: omniauth_identities
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  provider   :string
#  uid        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :omniauth_identity do
    user ""
provider "MyString"
uid "MyString"
  end

end
