class StaticPagesController < ApplicationController
  def show
    @static_page = StaticPage.find params[:id]
  end

  def landing
    render file: Rails.public_path.join("landing.html"), layout: false
  end
end
