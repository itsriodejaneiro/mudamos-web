# == Schema Information
#
# Table name: session_tokens
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  token      :string
#  expire_at  :datetime
#  platform   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe SessionToken, type: :model do

  subject { FactoryGirl.build(:session_token) }
  let(:session_token) { FactoryGirl.create(:session_token) }

  # PRESENCE
  it 'should validate the presence of platform' do
    should validate_presence_of :platform
  end

  it 'should belong to user' do
    should belong_to :user
  end


  #RESPONDS
  [:id, :user_id, :token,
   :expire_at, :platform,
   :created_at, :updated_at].each do |method|

    it "should respond to #{method}" do
      should respond_to(method)
    end
  end


  context "callbacks" do
    # http://guides.rubyonrails.org/active_record_callbacks.html
    # https://github.com/beatrichartz/shoulda-callback-matchers/wiki

    [:set_token, :set_expiry_date].each do |method|
      it "should call #{method} before create" do
        expect(session_token).to callback(method).before(:create)
      end
    end

    context "set the correct attributes" do

      before(:each) do
        @token = FactoryGirl.build(:session_token)
      end

      it "set_expiry_date should alter expire_at" do
        Timecop.freeze(Time.now)
        expect{ @token.save }.to change{ @token.expire_at }.from(nil).to(Time.now + 2.days)
        Timecop.return
      end
      
      it "set_token should alter token" do
        old_token = @token.token

        expect { @token.save }.to change { @token.token }.from(old_token)
      end

    end
  end

  describe "scopes" do
    # It's a good idea to create specs that test a failing result for each scope, but that's up to you
    #  scope :valid_for, lambda { |plat| where('expire_at >= ? AND platform = ?', Time.now, plat) }
    before(:each) do
      ['android', 'ios', 'web'].each do |plat|
        2.times do
          create(:session_token, platform: plat)
        end
      end
    end

    ['android', 'ios', 'web'].each do |plat|
      it ".valid_for(platform) returns all valid tokens for that platform" do
        Timecop.freeze(Time.now)
        expect(SessionToken.valid_for(plat).pluck(:id)).to eq(SessionToken.where(platform: plat).pluck(:id))
        Timecop.return
      end

      it ".valid_for(platform) does not returns valid tokens for that platform with different date" do
        Timecop.freeze(Time.now + 3.days)
        expect(SessionToken.valid_for(plat)).to be_blank
        Timecop.return
      end
    end
  end
end
