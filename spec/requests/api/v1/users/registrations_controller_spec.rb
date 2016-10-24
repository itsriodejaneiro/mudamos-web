require 'rails_helper'

describe 'Api::V1::User::RegistrationsController', type: :request do

  let!(:test_user){FactoryGirl.build(:user)}

  let!(:default_header){
    {
      :'Content-Type' => 'application/json',
      :'Accept' => 'application/json',
      :'X-PLATFORM' => 'web'
    }
  }

  it_should_behave_like 'base_controller', '/api/v1/users', [:'X-PLATFORM']

  def post_data body = nil, header = nil
    body ||= {
      user: FactoryGirl.attributes_for(:user, profile_id: Profile.roots.first.id)
    }
    header ||= default_header
    post '/api/v1/users/', body.to_json, default_header
  end

  describe 'when user is not created and a sign up request (POST) is made' do

    context 'with correct data' do
      before(:each) do
        post_data
      end

      it 'should get json response' do
        expect(response.content_type).to eq("application/json")
      end

      it 'should get 201 status response header' do
        expect(response).to have_http_status(201)
      end

      it 'should set the @user variable as a User' do
        expect(assigns(:user)).to be_a(User)
      end

      it 'should have the resoruce method' do
        expect(controller.resource).to eq(assigns(:user))
      end

      it "should have the correct strong parameters" do
        expect(controller.send(:user_params).keys).to eq(
          [
            "name",
            "email",
            "password",
            "password_confirmation",
            "profile_id",
            "birthday",
            "city",
            "state",
            "gender",
            'first_step',
            'alias_name',
            'alias_as_default'
          ]
        )
      end

      it 'should get valid token' do
        created_user_token = JSON.parse(response.body)["auth_token"]
        user = SessionToken.find_by_token(created_user_token).user
        expect(user.email).to eq(controller.resource.email)
      end
    end

    context "with correct data" do
      it "should create a user" do
        expect { post_data }.to change { User.count }.by(1)
      end

      it "should create a SessionToken" do
        expect { post_data }.to change { SessionToken.count }.by(1)
      end
    end

    context 'with missing data' do
      [:name,:password, :password_confirmation, :email].each do |attr|
        before(:each) do
          @user_body = {
            user: FactoryGirl.attributes_for(:user, profile_id: 1)
          }
          @user_body[:user].except!(attr)
        end

        describe "- #{attr} -" do
          before(:each) do
            post_data @user_body
          end

          it 'should get json response' do
            expect(response.content_type).to eq("application/json")
          end

          it 'should set the @user variable as a User' do
            expect(assigns(:user)).to be_a(User)
          end

          it 'should have a formatted json response' do
            expect(response.body).to eq(
              {
                user: {
                  errors: assigns(:user).errors
                }
              }.to_json
            )
          end

          it 'should get 422 status response header' do
            expect(response).to have_http_status(422)
          end
        end

        describe "- #{attr} -" do
          it 'should not create user' do
            expect { post_data @user_body }.not_to change { User.count }
          end
        end
      end
    end

  end

  def put_header token=nil
    default_header[:Authorization] = "Token token=#{token}"
  end

  def put_data body = nil, header = nil
    body ||= {
        user: {name:"nome alterado"}
    }
    header
    put '/api/v1/users/', body.to_json, default_header
  end

  describe 'when user is created and a edit request (PUT/PATCH) is made' do
    context 'with correct data' do
      {:name => Faker::Name.name, :email => Faker::Internet.email,
       :password => Faker::Internet.password ,
       :birthday =>  Date.new(1986), :city => "São Paulo", :state => "São Paulo",
       :gender => rand(1..3) , :alias_as_default=> true}.each do |k,v|

        describe "- #{k} -" do
          before(:each) do
            @user = FactoryGirl.create(:user, gender: 0)
            session_token = @user.ensure_session_token_for 'web'
            header = put_header(session_token.token)
            @update_body = {
                user: {k => v}
            }
            put_data @update_body, header
          end

          it 'should get json response' do
            expect(response.content_type).to eq("application/json")
          end

          it 'should get 200 status response header' do
            expect(response).to have_http_status(200)
          end

          it 'should set the @user variable as a User' do
            expect(assigns(:user)).to be_a(User)
          end

          it 'should have the resource method' do
            expect(controller.resource).to eq(assigns(:user))
          end

          it "should alter #{k} attribute to #{v}" do
            expected_response = v
            if k == :gender
              g =  ['Masculino', 'Feminino' , 'Transgênero', 'Não quero opinar']
              expected_response = g[v]
            end

            if k == :birthday
              expected_response = v.strftime("%d/%m/%Y")
            end
            expect( controller.resource.send k  ).to eq( expected_response )
          end
        end

      end

    end

    context "with correct data" do

    end

    context 'with no data' do
      before(:each) do
        @user = FactoryGirl.create(:user)
        @user_copy = @user
        session_token = @user.ensure_session_token_for 'web'
        header = put_header(session_token.token)
        put_data '', header
      end

      it 'should get json response' do
        expect(response.content_type).to eq("application/json")
      end

      it 'should get 422 status response header' do
        expect(response).to have_http_status(422)
      end

      it 'should set the @user variable to nil' do
        expect(assigns(:user)).to be(nil)
      end

      it 'should have the resource method' do
        expect(controller.resource).to eq(assigns(:user))
      end

      it 'should not alter user' do
        expect(@user).to eq(@user_copy)
      end
    end

  end


end
