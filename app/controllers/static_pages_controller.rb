class StaticPagesController < ApplicationController
  def show
    @static_page = StaticPage.find params[:id]
  end
end
