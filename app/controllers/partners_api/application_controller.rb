require_dependency 'api/entities_helpers'

class PartnersApi::ApplicationController < ActionController::Base
  Grape::Entity.include Api::UrlHelpers

  before_action :doorkeeper_authorize!
end
