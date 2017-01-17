require 'rails_helper'

RSpec.describe Admin::CyclesController, type: :controller do

  let(:cycle) { create_cycle_with_phase phases: [{ plugin_type: :report }] }

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
      get :show, id: cycle.id
      expect(response).to have_http_status(:success)
    end
  end

end
