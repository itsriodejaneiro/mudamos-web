# == Schema Information
#
# Table name: internal_notifications
#
#  id              :integer          not null, primary key
#  notification_id :integer
#  read_at         :datetime
#  deleted_at      :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'rails_helper'

RSpec.describe InternalNotification, type: :model do
  [:comment, :like, :dislike].each do |obj|
    fac_name = "#{obj}_internal_notification"
    include_examples 'paranoia', fac_name

    it 'should validate presence of notification' do
      should validate_presence_of :notification
    end

    [:id, :notification_id, :notification,
     :read_at, :notify, :deleted_at, :created_at, :updated_at].each do |attr|
      it "should respond_to #{attr}" do
        should respond_to attr
      end
    end

    it 'should set the read_at attribute after notify method is called' do
      notification = FactoryGirl.create(fac_name)
      Timecop.freeze(Time.now)
      expect{ notification.notify }.to change{ notification.read_at }.from(nil).to(Time.now)
      Timecop.return
    end
  end
end
