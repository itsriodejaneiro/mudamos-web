class SearchController < ApplicationController

  def show
    @results = Search.find params[:search]

    render partial: 'layouts/search_results'
  end

end
