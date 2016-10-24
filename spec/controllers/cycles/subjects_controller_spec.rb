require 'rails_helper'

RSpec.describe Cycles::SubjectsController, type: :controller do

  describe "GET #index" do
    before do
      @cycle = FactoryGirl.create(:cycle)
      get :index, cycle_id: @cycle.id
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #show" do
    before do
      @cycle_subject = FactoryGirl.create(:cycle_subject)
      get :show, id: @cycle_subject.id, cycle_id: @cycle_subject.plugin_relation.cycle.id
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end
  end

end
