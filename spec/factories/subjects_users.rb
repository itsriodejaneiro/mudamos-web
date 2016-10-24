# == Schema Information
#
# Table name: subjects_users
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  subject_id   :integer
#  agree        :boolean          default(FALSE)
#  deleted_at   :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  is_anonymous :boolean
#

FactoryGirl.define do
  factory :subject_user do
    association :user
    association :subject, factory: :cycle_subject
    agree false
    is_anonymous true
  end

end
