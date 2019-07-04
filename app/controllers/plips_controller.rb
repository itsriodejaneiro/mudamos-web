class PlipsController < ApplicationController
  layout "static"

  caches_action :index, expires_in: 10.minutes, cache_path: -> do
    params.slice(:scope_coverage)
  end

  def index
    @title = "Mudamos | Assine um projeto"
    @image = asset_url("screenshot_plips.png")
    @description= "Transforme a sua cidade, o seu estado e o país."

    plip_repository = PlipRepository.new
    @plips = plip_repository.all_initiated(filters: filters, limit: 100)
  end

  def filters
    @filters ||= {
      scope: scope,
      include_causes: include_causes,
    }
  end

  def scope
    params[:scope_coverage] || "all"
  end

  def include_causes
    scope == "all"
  end
end
