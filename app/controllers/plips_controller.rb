class PlipsController < ApplicationController
  layout "static"

  def index
    plip_repository = PlipRepository.new
    @plips = plip_repository.all_initiated(filters: { scope: params[:scope_coverage] || "all" })
  end
end
