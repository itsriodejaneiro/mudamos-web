class Api::V3::PlipsController < Api::V3::ApplicationController
  attr_writer :plip_repository

  def plip_repository
    @plip_repository ||= PlipRepository.new
  end

  def show
    plip_id = params[:id]
    plip = plip_repository.find_plip_by_id(plip_id)

    render json: success_response(Api::V3::Entities::Plip.represent(plip))
  end
end
