# == Schema Information
#
# Table name: subjects_users
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  subject_id   :integer
#  agree        :boolean          default(FALSE)
#  deleted_at   :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  is_anonymous :boolean
#

require 'rails_helper'

RSpec.describe SubjectUser, type: :model do
  subject { FactoryGirl.build_stubbed(:subject_user) }
  let(:subject_user) { FactoryGirl.build(:subject_user) }

  # PRESENCE
  [:subject_id, :user_id].each do |attr|
    it  "should validate the presence of #{attr} " do
      should validate_presence_of attr
    end
  end

  #RESPONDS_TO
  [:id, :user_id, :subject_id, :agree, :deleted_at, :created_at,
   :updated_at, :toggle_anonymity, :is_anonymous?].each do |method|
    it "should respond to #{method}" do
      should respond_to(method)
    end
  end

  context 'anonymity toggle' do
    before(:each) do
      @subject_user = FactoryGirl.build(:subject_user)
    end
    [ true, false ].each do |value|
      it "should toggle anonymity from #{value} to #{!value}" do
        @subject_user.is_anonymous = value
        expect{ @subject_user.toggle_anonymity }.to change{ @subject_user.is_anonymous? }.from(value).to(!value)
      end
    end
  end
  include_examples 'paranoia'
end
