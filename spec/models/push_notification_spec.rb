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

require 'rails_helper'

RSpec.describe PushNotification, type: :model do
  [:comment, :like, :dislike].each do |obj|
    fac_name = "#{obj}_push_notification"
    context "#{fac_name}" do

      include_examples 'paranoia', fac_name

      it 'should validate presence of notification' do
        should validate_presence_of :notification
      end


      [:id, :notification_id, :notification,
       :sent_at, :notify, :deleted_at, :created_at, :updated_at].each do |attr|
        it "should respond_to #{attr}" do
          should respond_to attr
        end
      end

      it 'should set the sent_at attribute after notify method is called' do
        notification = FactoryGirl.create(fac_name)
        Timecop.freeze(Time.now)
        expect{ notification.notify }.to change{ notification.sent_at }.from(nil).to(Time.now)
        Timecop.return
      end
    end
  end
end
