# == Schema Information
#
# Table name: dislikes
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  comment_id :integer
#  deleted_at :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :dislike do
    association :user, factory: :user
    association :comment, factory: :comment
  end

end
