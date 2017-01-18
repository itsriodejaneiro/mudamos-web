require 'rails_helper'

RSpec.describe Admin::Cycles::UsersController, type: :controller do

  before(:each) do
    admin = FactoryGirl.create(:admin_user)
    sign_in admin
  end

  after(:each) do
    sign_out :admin_user
  end

  let(:cycle) { create_cycle_with_phase phases: [{ plugin_type: :report }] }

  describe "GET #index" do
    it "returns http success" do
      get :index, cycle_id: cycle.id
      expect(response).to have_http_status(:success)
    end
  end

end
