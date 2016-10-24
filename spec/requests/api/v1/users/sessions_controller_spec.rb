require 'rails_helper'

describe "Api::V1::#{TEST_USER_CLASS.to_s.camelize}::SessionsController", type: :request do

  let!(:test_user) { FactoryGirl.create(TEST_USER_CLASS) }

  let(:default_header) {
    {
      :'Content-Type' => 'application/json',
      :'Accept' => 'application/json',
      :'X-PLATFORM' => 'web'
    }
  }

  it_should_behave_like 'base_controller', '/api/v1/users/sign_in', [:Authorization,:'X-PLATFORM']

  def post_request_data body = nil, header = nil
    body ||= {
      TEST_USER_CLASS => {
        email: test_user.email,
        password: '12345678'
      }
    }
    header ||= default_header
    post '/api/v1/users/sign_in', body.to_json, default_header
  end

  def post_request_wrong_data header = nil
    header ||= default_header

    post_request_data({
      TEST_USER_CLASS => {
        email: test_user.email,
        password: '1234'
      }
    })
  end

  def delete_request_data header
    delete '/api/v1/users/sign_out', {}, header
  end

  describe 'when a sign_in request (POST) is made' do
    context 'with correct data' do
      it 'should get json response' do
        post_request_data
        expect(response.content_type).to eq("application/json")
      end

      it 'should get 201 status response header' do
        post_request_data
        expect(response).to have_http_status(201)
      end

      it 'should login the user' do
        post_request_data
        expect(controller.current_user).to eq(test_user)
      end

      it 'should get valid token' do
       expect { post_request_data }.to change { SessionToken.count }.by(1)
      end
    end

    context 'with wrong password' do
      it 'should get json response' do
        post_request_wrong_data
        expect(response.content_type).to eq("application/json")
      end

      it 'should get 422 status response header' do
        post_request_wrong_data
        expect(response).to have_http_status(422)
      end

      it 'should not get valid token' do
        expect { post_request_wrong_data }.not_to change { SessionToken.count }
      end

      it 'should not login the user' do
        post_request_wrong_data
        expect(controller.current_user).to be_nil
      end
    end

  end

  describe "when logged in" do
    before(:each) do
      @session_token = FactoryGirl.create(:session_token)
    end
    context 'with correct token'do
      before(:each) do
        @new_header = default_header.merge(:'Authorization' => "Token token=#{@session_token.token}")
      end
      it 'should return status 200' do
        delete_request_data @new_header
        expect(response).to have_http_status(200)
      end

      it 'should return JSON' do
        delete_request_data @new_header
        expect(response.content_type).to eq("application/json")
      end

      it 'should delete token' do
        expect{
          delete_request_data @new_header
        }.to change {
          SessionToken.count
        }.by(-1)
      end
    end

    context 'with incorrect token' do
      before(:each) do
        @new_header = default_header.merge(:'Authorization' => "Token token=12345")
      end

      it 'should return status 401' do
        delete_request_data @new_header
        expect(response).to have_http_status(401)
      end

      it 'should return JSON' do
        delete_request_data @new_header
        expect(response.content_type).to eq("application/json")
      end

      it 'should not delete token' do
        expect {
          delete_request_data @new_header
        }.not_to change {
          SessionToken.count
        }
      end
    end
  end
end
