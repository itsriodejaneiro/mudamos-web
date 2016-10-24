# == Schema Information
#
# Table name: subjects
#
#  id                 :integer          not null, primary key
#  plugin_relation_id :integer
#  enunciation        :string
#  slug               :string
#  deleted_at         :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  question           :text
#  title              :string
#  vocabulary_id      :integer
#  tag_description    :text
#

FactoryGirl.define do
  factory :base_subject, class: 'Subject' do
    sequence(:enunciation) { |n| "Enunciation #{n}" }
    sequence(:question) { |n| "Question #{n} ?" }
    sequence(:title) { |n| "Title #{n} ?" }
   sequence(:slug) { |n| "Slug#{n}" }
    factory :phase_subject do
      association :plugin_relation, factory: :phase_plugin_relation
    end

    factory :cycle_subject do
      association :plugin_relation, factory: :cycle_plugin_relation
    end
  end

end
