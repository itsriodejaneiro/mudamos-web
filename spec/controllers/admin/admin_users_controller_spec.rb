require 'rails_helper'

RSpec.describe Admin::AdminUsersController, type: :controller do

  before(:each) do
    admin = FactoryGirl.create(:admin_user, admin_type: AdminUser.admin_types["Master"])
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
    let(:admin_user) { FactoryGirl.create :admin_user }
    it "returns http success" do
      get :show, id: admin_user.id
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #edit" do
    let(:admin_user) { FactoryGirl.create :admin_user }
    it "returns http success" do
      get :edit, id: admin_user.id
      expect(response).to have_http_status(:success)
    end
  end

end
