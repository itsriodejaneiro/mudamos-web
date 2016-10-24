# == Schema Information
#
# Table name: cycles
#
#  id                   :integer          not null, primary key
#  name                 :string
#  subdomain            :string
#  title                :string
#  about                :string
#  initial_date         :datetime
#  final_date           :datetime
#  slug                 :string
#  deleted_at           :datetime
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  color                :string
#  description          :string
#  picture_file_name    :string
#  picture_content_type :string
#  picture_file_size    :integer
#  picture_updated_at   :datetime
#

file = File.new "#{Rails.root}/app/assets/images/test/test_image.jpg", "r"

FactoryGirl.define do
  factory :cycle do
    sequence(:name) { |n| "Ciclo #{n}" }
    sequence(:subdomain) { |n| "Sub-Dominio #{n}" }
    sequence(:title) { |n| "Título #{n}" }
    sequence(:about) { |n| "Sobre #{n}" }
    initial_date Date.parse("2015-09-02 14:56:46")
    final_date Date.parse("2015-10-02 14:56:46")
    sequence(:slug) { |n| "Slug#{n}" }
    sequence(:description) { |n| "Description#{n}"}
    sequence(:color){|n|  "#FFFF#{n}"}

    # picture { file }
    picture_file_name 'teste.png'
    picture_content_type 'image/png'
    picture_file_size '1000'
    picture_updated_at Time.zone.now
  end

end
