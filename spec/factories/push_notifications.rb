# == Schema Information
#
# Table name: push_notifications
#
#  id              :integer          not null, primary key
#  notification_id :integer
#  sent_at         :datetime
#  deleted_at      :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

FactoryGirl.define do
  factory :push_notification do
    ['comment', 'like', 'dislike'].each do |obj|
      fac_name = "#{obj}_push_notification"
      factory fac_name.to_sym do
        association :notification, factory:"#{obj}_notification".to_sym
      end
    end
  end

end
