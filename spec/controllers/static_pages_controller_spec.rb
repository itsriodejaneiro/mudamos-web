require 'rails_helper'

RSpec.describe StaticPagesController, type: :controller do

  describe "GET #show" do
    let(:static_page) { create :static_page }

    it "returns http success" do
      get :show, id: static_page.id
      expect(response).to have_http_status(:success)
    end
  end
end
