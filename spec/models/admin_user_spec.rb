# == Schema Information
#
# Table name: admin_users
#
#  id                     :integer          not null, primary key
#  name                   :string
#  password               :string
#  deleted_at             :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  admin_type             :integer          default(0)
#

require 'rails_helper'

RSpec.describe AdminUser, type: :model do

  subject { FactoryGirl.build_stubbed(:admin_users) }
  let(:admin_users) { FactoryGirl.build(:admin_users) }

  include_examples 'paranoia'

  # PRESENCE
  [:email].each do |attr|
    it "should validate the presence of #{attr}" do
      should validate_presence_of attr
    end
  end


  # UNIQUENESS
  [:email].each do |attr|
    it "should validate the uniqueness of #{attr}" do
      admin_user.should validate_uniqueness_of attr
    end
  end

  # E-MAIL SHOULD BE DOWNCASED WHEN SAVED
  ['teste@example.com', 'TeStE@ExAmPlE.CoM', 'TESTE@EXAMPLE.COM', 'tEsTe@eXaMpLe.cOm'].each do |e|
    describe "when the e-mail is #{e}" do
      before(:each) do
        @admin_user = FactoryGirl.build(:admin_users, email: e)
        @admin_user.save
      end

      it 'should be down cased when saved' do
        expect(@admin_user.reload.email).to eq(e.downcase)
      end
    end
  end

  # making sure the DEVISE MODULES are all loaded
  [:database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable].each do |mod|
    it "should include the devise module #{mod}" do
      expect(admin_user.devise_modules).to include(mod)
    end
  end


end
