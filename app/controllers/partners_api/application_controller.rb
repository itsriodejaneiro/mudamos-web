require_dependency 'api/entities_helpers'

class PartnersApi::ApplicationController < ActionController::Base

  before_action :doorkeeper_authorize!
end
