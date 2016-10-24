class Cycles::MaterialsController < ApplicationController
  before_action :set_cycle

  def index
    if params[:filter]
      t = ActsAsTaggableOn::Tag.find(params[:filter])
      @materials = Material.where(id: @cycle.materials.tagged_with(t.name).pluck(:id).uniq)
    else
      @materials = Material.where(id: @cycle.materials.pluck(:id).uniq)
    end

    if params[:search] and not params[:search].blank?
      @materials = @materials.material_search(params[:search])
    end
  end

  private

    def set_cycle
      @cycle = Cycle.find params[:cycle_id]
    end

end
