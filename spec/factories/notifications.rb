# == Schema Information
#
# Table name: notifications
#
#  id                 :integer          not null, primary key
#  target_user_id     :integer
#  target_user_type   :string
#  target_object_id   :integer
#  target_object_type :string
#  title              :text
#  description        :text
#  view_url           :string
#  deleted_at         :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  picture_url        :string
#

FactoryGirl.define do
  factory :notification do

    association :target_user, factory: :user
    view_url "wwww.mudamos.org"
    ['comment', 'like', 'dislike'].each do |obj|
        fac_name = "#{obj}_notification"
        factory fac_name.to_sym do
          association :target_object, factory: obj.to_sym
          title fac_name
          description fac_name
        end
    end

  end
end
