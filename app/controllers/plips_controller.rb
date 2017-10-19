class PlipsController < ApplicationController
  layout "static"

  def index
    plip_repository = PlipRepository.new
    @plips = plip_repository.all_initiated(filters: filters)
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
