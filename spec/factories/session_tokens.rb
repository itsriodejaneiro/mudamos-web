# == Schema Information
#
# Table name: session_tokens
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  token      :string
#  expire_at  :datetime
#  platform   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :session_token do
    user_id {FactoryGirl.create(:user).id}
    token "123456789"
    platform "web"
  end

end
