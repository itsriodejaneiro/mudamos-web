require 'rails_helper'

RSpec.describe Admin::BlogPostsController, type: :controller do
  describe 'Authorized access' do
    before(:each) do
      @admin  = FactoryGirl.create(:admin_user)
      sign_in @admin
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
        @post = FactoryGirl.create(:blog_post)
        get :show, id: @post.id
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
      it "returns http success" do
        @post = FactoryGirl.create(:blog_post)
        get :edit, id: @post.id
        expect(response).to have_http_status(:success)
      end
    end
  end

end
