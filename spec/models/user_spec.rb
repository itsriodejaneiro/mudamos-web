# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  deleted_at             :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  profile_id             :integer
#  birthday               :date
#  picture_file_name      :string
#  picture_content_type   :string
#  picture_file_size      :integer
#  picture_updated_at     :datetime
#  alias_as_default       :boolean          default(FALSE)
#  sub_profile_id         :integer
#  gender                 :integer
#  encrypted_name         :string
#  encrypted_cpf          :string
#  encrypted_birthday     :string
#  encrypted_state        :string
#  encrypted_city         :string
#  encrypted_alias_name   :string
#  encrypted_email        :string
#  is_admin               :boolean          default(FALSE)
#

require 'rails_helper'

RSpec.describe User, type: :model do

  subject { FactoryGirl.build_stubbed(:user) }
  let(:user) { FactoryGirl.build(:user) }

  include_examples 'paranoia'

  # PRESENCE
  [:name, :email, :birthday, :state, :city, :profile, :profile_id, :gender].each do |attr|
    it "should validate the presence of #{attr} for complete user" do
      should validate_presence_of attr
    end
  end

  describe 'first step user' do
    before(:each) do
      @first_step_user = FactoryGirl.build(:first_step_user)
    end
    [:name, :email,  :birthday].each do |attr|
      it "should validate the presence of #{attr} for complete user" do
        @first_step_user.should validate_presence_of attr
      end
    end
  end

  describe 'user with valid profile' do
    before(:each) do
      @user_with_valid_sp = FactoryGirl.build(:user_with_valid_sub_profile)
    end

    it 'should validate the presence of sub_profile' do
      @user_with_valid_sp.should validate_presence_of :sub_profile
    end

    it 'should not be valid when the sub_profile is not set' do
      @user_with_valid_sp.sub_profile_id = nil
      expect(@user_with_valid_sp).to be_invalid
    end

    it 'should not validate sub_profile when profile has no children' do
      user.should_not validate_presence_of :sub_profile
    end

  end

  describe 
  [:name, :email, :birthday, :state, :city, :profile, :profile_id, :gender].each do |attr|
    it "should validate the presence of #{attr} for complete user" do
      should validate_presence_of attr
    end
  end

  # UNIQUENESS
  describe 'testing uniqueness' do
    before(:each) do
      @valid_user = FactoryGirl.create(:user)
      @invalid_user = FactoryGirl.build(:user, email: @valid_user.email)
    end
    it " if emails are equal should be invalid" do
      expect(@invalid_user).to be_invalid
    end

    it " if emails are different should be valid" do
      @invalid_user.email = Faker::Internet.email
      expect(@invalid_user).to be_valid
    end


  end


  it 'should belong to profile' do
    should belong_to :profile
  end

  # E-MAIL SHOULD BE DOWNCASED WHEN SAVED
  ['teste@example.com', 'TeStE@ExAmPlE.CoM', 'TESTE@EXAMPLE.COM', 'tEsTe@eXaMpLe.cOm'].each do |e|
    describe "when the e-mail is #{e}" do
      before(:each) do
        @user = FactoryGirl.build(:user, email: e)
        @user.save
      end

      it 'should be down cased when saved' do
        expect(@user.reload.email).to eq(e.downcase)
      end
    end
  end

  # making sure the DEVISE MODULES are all loaded
  [:database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable].each do |mod|
    it "should include the devise module #{mod}" do
      expect(user.devise_modules).to include(mod)
    end
  end


end
