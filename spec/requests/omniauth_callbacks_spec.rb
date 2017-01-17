require 'spec_helper'
require 'rails_helper'

describe Users::OmniauthCallbacksController, type: :controller do

  let(:user) { create :user }

	before do
    allow(User).to receive(:find_for_oauth).and_return user
    OmniAuth.config.test_mode = true
    OmniAuth.config.add_mock(:facebook, {:uid => '12345'})

    request.env["devise.mapping"] = Devise.mappings[:user]
    request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
  end

  before(:each) do
    get :facebook
  end

  it "should set user_id" do
    user_id = session["warden.user.user.key"][0][0]
    expect(user_id).to eq(user.id)
  end

  it "should redirect to root" do
    expect(response).to redirect_to root_path
  end
end
