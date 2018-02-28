class StaticController < ApplicationController
  layout "static"

  caches_action :index, expires_in: 30.minutes
  caches_action :about, expires_in: 1.hour

  def about
  end

  def index
  end
end
