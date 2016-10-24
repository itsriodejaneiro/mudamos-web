# == Schema Information
#
# Table name: phases
#
#  id                   :integer          not null, primary key
#  cycle_id             :integer
#  name                 :string
#  description          :string
#  tooltip              :string
#  initial_date         :datetime
#  final_date           :datetime
#  slug                 :string
#  deleted_at           :datetime
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  picture_file_name    :string
#  picture_content_type :string
#  picture_file_size    :integer
#  picture_updated_at   :datetime
#

file = File.new "#{Rails.root}/app/assets/images/test/test_image.jpg", "r"

FactoryGirl.define do
  factory :phase do
    association :cycle
    sequence(:name)  { |n| "Nome #{n}" }
    sequence(:description)  { |n| "Desc #{n}" }
    sequence(:tooltip) { |n| "ToolTip#{n}" }
    sequence(:slug) { |n| "slug#{n}"}

    initial_date { Time.zone.now }
    final_date { Time.zone.now + 2.months }

    # picture { file }
    picture_file_name 'teste.png'
    picture_content_type 'image/png'
    picture_file_size '1000'
    picture_updated_at Time.zone.now

    factory :shortly_phase do
      initial_date { Time.zone.now + 1.month }
      final_date { Time.zone.now + 2.months }
    end

    factory :in_progress_phase do
      initial_date { Time.zone.now - 1.month }
      final_date { Time.zone.now + 1.month }
    end

    factory :finished_phase do
      initial_date { Time.zone.now - 3.months }
      final_date { Time.zone.now - 1.month }
    end
  end

end
