class Api::V1::BaseController < ActionController::Base
  before_filter :authenticate_user_from_token
  prepend_before_filter :get_platform

  private

    def get_platform
      if platform = request.headers['X-Platform']
        params[:platform] = platform
      else
        render_bad_header 'X-Platform'
      end
    end

    def authenticate_user_from_token
      t = authenticate_with_http_token do |token, options|
        session_token = SessionToken.where(token: token).first
        if session_token
          user = session_token.user

          if user && Devise.secure_compare(session_token.token, token)
            sign_in user, store: false
          end
        end
      end

      unless t
        if user_signed_in?
          sign_out current_user
        end
      end
    end

    def render_unauthorized
      self.headers['WWW-Authenticate'] = 'Token realm="Application"'

      render json: {
        user: {
          errors: {
            session: [
              "Bad Credentials"
            ]
          }
        }
      }, status: 401

      unless t
        if user_signed_in?
          sign_out current_user
        end
      end
    end

    def render_bad_header header
      render json: {
        header: {
          errors: {
            "#{header}" => [
              "Bad Header: #{header} header is missing"
            ]
          }
        }
      }, status: 422
    end

    def render_bad_params parameter
      render json: {
        params: {
          errors: {
            "#{parameter}" => [
              "Bad Params: #{parameter} parameter is missing"
            ]
          }
        }
      }, status: 422
    end
end
