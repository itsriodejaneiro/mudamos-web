# == Schema Information
#
# Table name: settings
#
#  id                   :integer          not null, primary key
#  key                  :string
#  value                :text
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  deleted_at           :datetime
#  picture_file_name    :string
#  picture_content_type :string
#  picture_file_size    :integer
#  picture_updated_at   :datetime
#

file = File.new "#{Rails.root}/app/assets/images/test/test_image.jpg", "r"
FactoryGirl.define do
  [:picture, :value, :picture_and_value].each do |type|
    factory "#{type}_setting".to_sym, class: Setting do
      sequence(:key) { |n| "Setting#{n}" }
      sequence(:value) {|n| "Setting#{n}"} unless type == :picture
      picture file unless type == :value
    end
  end

  factory :setting do
    sequence(:key) { |n| "Setting#{n}" }
    sequence(:value) {|n| "Setting#{n}"}
  end

end
