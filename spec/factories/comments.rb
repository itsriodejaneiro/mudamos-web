# == Schema Information
#
# Table name: comments
#
#  id                     :integer          not null, primary key
#  subject_id             :integer
#  user_id                :integer
#  content                :text
#  was_intermediated      :boolean          default(FALSE)
#  should_show_alias      :boolean
#  parent_id              :integer
#  lft                    :integer          not null
#  rgt                    :integer          not null
#  depth                  :integer          default(0), not null
#  children_count         :integer          default(0), not null
#  likes_count            :integer          default(0), not null
#  dislikes_count         :integer          default(0), not null
#  reports_count          :integer          default(0), not null
#  comment_versions_count :integer          default(0), not null
#  slug                   :string
#  deleted_at             :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  is_anonymous           :boolean
#

FactoryGirl.define do
  factory :comment do
    association :user
    association :subject, factory: :cycle_subject
    sequence(:content) { |n| "Comment #{n}" }
    was_intermediated false
    should_show_alias false
    sequence(:slug)    { |n| "comment-#{n}" }


    trait :with_children do
      transient do
        number_of_children 1
      end

      after(:build) do |parent, evaluator|
        create_list(:comment, evaluator.number_of_children, parent: parent, user: parent.user)
      end
    end


  end

end
