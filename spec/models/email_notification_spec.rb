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

require 'rails_helper'

RSpec.describe EmailNotification, type: :model do

  before { allow(StaticPage).to receive(:find_by_slug).and_return(FactoryGirl.create(:static_page)) }

  [:comment, :like, :dislike].each do |obj|
    fac_name = "#{obj}_email_notification"
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

    describe "#save" do
      it "sents the notification and updates its sent_at attribute" do
        notification = FactoryGirl.build(fac_name)
        Timecop.freeze(Time.now)
        expect{ notification.save }.to change{ notification.sent_at }.from(nil).to(Time.now)
        Timecop.return
      end
    end
  end



end
