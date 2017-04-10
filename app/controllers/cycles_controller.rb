class CyclesController < ApplicationController
  before_action :home_blocks, only: %i(index)

  def home_block_repository
    @home_block_repository ||= HomeBlockRepository.new
  end

  def index
    @highlights = GridHighlight.order('id ASC').all
  end

  def show
    @cycle = Cycle.find params[:id]
  end

  def home_blocks
    @home_blocks ||= home_block_repository.blocks
  end
  helper_method :home_blocks
end
