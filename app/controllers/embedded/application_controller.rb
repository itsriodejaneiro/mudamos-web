class Embedded::ApplicationController < ActionController::Base

  after_filter :allow_iframe

  private

  def allow_iframe
    response.headers.delete "X-Frame-Options"
  end
end
