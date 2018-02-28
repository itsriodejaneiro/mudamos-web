class StaticPagesController < ApplicationController
  caches_action :show, expires_in: 10.minutes

  def show
    @static_page = StaticPage.find params[:id]
  end
end
