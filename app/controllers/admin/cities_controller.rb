class Admin::CitiesController < Admin::ApplicationController
  def index
    @cities = City.all.limit(10)
    @cities = City.where("name ilike ?", "#{params[:name]}%") if params[:name]

    render json: {
      cities: @cities.map { |city| { id: city.id, name: city.name, uf: city.uf } }
    }
  end
end
