# == Schema Information
#
# Table name: email_notifications
#
#  id              :integer          not null, primary key
#  notification_id :integer
#  to_email        :string
#  from_email      :string
#  subject         :text
#  content         :text
#  sent_at         :datetime
#  deleted_at      :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

FactoryGirl.define do
  factory :email_notification do
    sequence(:subject) { |n| "#{Faker::Lorem.paragraph}-#{n}"}
    sequence(:content) { |n| "#{Faker::Lorem.paragraph}-#{n}"}
    sequence(:to_email) {|n| "#{Faker::Internet.free_email("user#{n}")}"}
    from_email "mudamos@mudamos.org.br"
    ['comment', 'like', 'dislike'].each do |obj|
      fac_name = "#{obj}_email_notification"
      factory fac_name.to_sym do
        association :notification, factory:"#{obj}_notification".to_sym
      end
    end
  end

end
