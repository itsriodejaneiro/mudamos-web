class CitiesController < ApplicationController
  respond_to :js

  def index
    if params[:uf].present?
      @cities = City.where(uf: params[:uf])

      @cities = @cities.where("name ilike ?", "#{params[:name]}%") if params[:name]

      render json: {
        cities: @cities.pluck(:name)
      }
    else
      render json: {
        cities: []
      }
    end
  end

end
