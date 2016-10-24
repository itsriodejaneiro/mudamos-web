class Api::V1::Users::OauthsController < Api::V1::Users::SessionsController

  def method_missing name
    nil
  end

  def facebook
    login_or_create_user('facebook')
  end

  def twitter
    login_or_create_user('twitter')
  end

  def google
    login_or_create_user('google')
  end

  def login_or_create_user network
    platform = params[:platform]

    omni_params = user_params
    omni_params['provider'] = network

    oauth_identity = OmniauthIdentity.find_for_oauth user_params
    
    @user = oauth_identity.user || User.find_by_email(user_params.email)

    if @user
      if oauth_identity.new_record?
        oauth_identity.user = @user
        oauth_identity.save!
      end

      auth_token = @user.ensure_session_token_for platform

      sign_in :user, @user
      render json: {
        auth_token: auth_token.token,
        email: @user.email
       }, status: 201
    else
      render status: 404, json: {
        errors: {
          user: {
            email: [
              'still not registered.'
            ]
          }
        }
      }
    end
  end


  def resource
    @user
  end

  protected

    def user_params
      #required OAuth_token, Provider, UID, Email
      OpenStruct.new( params.permit(
          :user =>[
            :email,
            :provider,
            :uid,
            :oauth
          ]
      )[:user] )
    end

  # def create_from_facebook data
  #   fbconnection = Koala::Facebook::API.new data.oauth
  #   user_data = fbconnection.get_object 'me?fields=id,name,email'

  #   email = user_data['email']
  #   password = Devise.friendly_token[0,20]

  #   user = User.new(
  #     email: email ? email : "changeme@#{ data.uid }-#{data.provider}.com",
  #     name: user_data['name'],
  #     password: password,
  #     password_confirmation: password
  #   )

  #   user.save!
  #   user
  # end

  # def create_from_twitter data
  #   twitter_access_token = data.oauth.split(' ')

  #   config = {
  #     access_token:        twitter_access_token[0],
  #     access_token_secret: twitter_access_token[1]
  #   }

  #   twconnection = Twitter::REST::Client.new config

  #   user_data = twconnection.user

  #   email = data.email
  #   password = Devise.friendly_token[0,20]

  #   user = User.new(
  #     email: email ? email : "changeme@#{ data.uid }-#{data.provider}.com",
  #     name: user_data.name,
  #     password: password,
  #     password_confirmation: password
  #   )

  #   user.save!
  #   user
  # end

  # def create_from_google(data)
  #   twitter_access_token = data.oauth.split(' ')

  #   config = {
  #     access_token:        twitter_access_token[0],
  #     access_token_secret: twitter_access_token[1]
  #   }

  #   twconnection = Twitter::REST::Client.new(config)

  #   user_data = twconnection.user

  #   email = data.email
  #   password = Devise.friendly_token[0,20]

  #   user = User.new(
  #     email: email ? email : "changeme@#{ data.uid }-#{data.provider}.com",
  #     name: user_data.name,
  #     password: password,
  #     password_confirmation: password
  #   )

  #   user.save!
  #   user
  # end
end

