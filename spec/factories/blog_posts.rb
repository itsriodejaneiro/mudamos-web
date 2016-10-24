# == Schema Information
#
# Table name: blog_posts
#
#  id                   :integer          not null, primary key
#  plugin_relation_id   :integer
#  title                :string
#  content              :text
#  picture              :string
#  picture_file_name    :string
#  picture_content_type :string
#  picture_file_size    :integer
#  picture_updated_at   :datetime
#  is_readonly          :boolean
#  release_date         :datetime
#  slug                 :string
#  deleted_at           :datetime
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  author_name          :string
#  active               :boolean          default(TRUE)
#  highlighted          :boolean          default(FALSE)
#

file = File.new "#{Rails.root}/app/assets/images/test/test_image.jpg", "r"

FactoryGirl.define do
  factory :blog_post do
    sequence(:plugin_relation) {FactoryGirl.create(:cycle_blog_plugin_relation)}
    sequence(:title) { |n| "#{Faker::Lorem.paragraph}-#{n}"}
    sequence(:content) {|n| "#{Faker::Lorem.paragraphs(4).map{|n| '<p>'+n+'</p>'}}#{n}"}
    sequence(:release_date) {Time.now}
    sequence(:slug){|n| "post-slug-#{n}"}

    # picture file
    picture_file_name 'teste.png'
    picture_content_type 'image/jpeg'
    picture_file_size '1000'
    picture_updated_at Time.zone.now
  end

end
