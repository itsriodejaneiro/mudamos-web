class Api::V1::Users::NotificationsController < Api::V1::ApplicationController
  def index
    if user_signed_in?
      self.collection = current_user.notifications
      super
    else
      render_401
    end
  end
end
