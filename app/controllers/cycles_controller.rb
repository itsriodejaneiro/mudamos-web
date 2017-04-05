class CyclesController < ApplicationController
  before_action :home_blocks, :app_landing_page, only: %i(index)

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

  def app_landing_page
    unless cookies[:has_seen_app_landing]
      cookies[:has_seen_app_landing] = {
        value: true,
        expires: 1.year.from_now,
        secure: !Rails.env.development?,
        httponly: true
      }

      render file: Rails.public_path.join("landing.html"), layout: false
    end
  end
end
