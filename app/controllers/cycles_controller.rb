class CyclesController < ApplicationController
  def index
    @highlights = GridHighlight.order('id ASC').all
  end

  def show
    @cycle = Cycle.find params[:id]
  end
end
