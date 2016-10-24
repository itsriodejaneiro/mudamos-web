# == Schema Information
#
# Table name: profiles
#
#  id                   :integer          not null, primary key
#  name                 :string
#  short_name           :string
#  description          :string
#  deleted_at           :datetime
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  picture_file_name    :string
#  picture_content_type :string
#  picture_file_size    :integer
#  picture_updated_at   :datetime
#  parent_id            :integer
#  lft                  :integer          not null
#  rgt                  :integer          not null
#  depth                :integer          default(0), not null
#  children_count       :integer          default(0), not null
#

file = File.new "#{Rails.root}/app/assets/images/test/test_image.jpg", "r"

FactoryGirl.define do
  factory :profile do
    sequence(:name) { |n| "Profile #{n}" }
    sequence(:short_name) { |n| "prof#{n}" }
    sequence(:description) { |n| "descrição do perfil #{n}"}

    # picture file
    picture_file_name 'teste.png'
    picture_content_type 'image/png'
    picture_file_size '1000'
    picture_updated_at Time.zone.now

    trait :with_children do
      transient do
        number_of_children 2
      end

      after(:build) do |parent, evaluator|
        create_list(:profile, evaluator.number_of_children, parent: parent)
      end
    end
  end

end
