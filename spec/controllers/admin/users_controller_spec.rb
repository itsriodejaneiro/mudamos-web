require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do

  let(:user) { FactoryGirl.create :user }

  before(:each) do
    admin = FactoryGirl.create(:admin_user)
    sign_in admin
  end

  after(:each) do
    sign_out :admin_user
  end

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #show" do
    it "returns http success" do
      get :show, id: user.id
      expect(response).to have_http_status(:success)
    end
  end

end
