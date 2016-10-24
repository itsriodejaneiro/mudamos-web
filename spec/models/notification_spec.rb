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

require 'rails_helper'

RSpec.describe Notification, type: :model do
  classes = [:comment, :like, :dislike]
  classes.each do |obj|
    fac_name = "#{obj}_notification"
    context "#{fac_name}" do

      include_examples 'paranoia', fac_name

      subject { FactoryGirl.build_stubbed(fac_name) }
      let(:notification) { FactoryGirl.build(fac_name) }

      context 'target_user tests' do
        it 'should belong to target_user' do
          should belong_to :target_user
        end

        it 'should have a target_user with user class' do
          notification.target_user.class.should be(User)
        end
      end

      context 'target_object tests' do
        it 'should belong to target_object' do
          should belong_to :target_object
        end

        it "should have a target_object with #{obj} class" do
          notification.target_object.class.should be(obj.to_s.camelize.constantize)
        end

        invalid_classes =  classes.reject { |a| a == obj }
        invalid_classes.each do |o|
          it "should not have a target_object with #{o} class" do
            notification.target_object.class.should_not be(o.to_s.camelize.constantize)
          end

        end
      end

      [:target_object, :target_user,
       :title, :description, :view_url].each do |attr|
        it "should validate the presence of #{attr}" do
          should validate_presence_of attr
        end

      end

    end
  end
end
