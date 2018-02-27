class PetitionsController < ApplicationController
  before_action :set_page_title, only: %i(verify)
  caches_action :signatures, expires_in: 10.minutes
  caches_action :verify, expires_in: 3.hours

  def verify
  end

  def signatures
    cycle
    @signatures = petition_service.fetch_petition_signatures(params[:petition_id])
  end

  def use_simple_header?
    params[:action] == "verify"
  end

  def approve
    attrs = params.require(:approver).permit(:email)
    PetitionPlugin::Approver.find_or_create_by email: attrs[:email], plugin_relation_id: params[:petition_id]
    render json: { store: url_for_store }
  end

  private

  def url_for_store
    store = Rails.application.secrets.mobile_app["store_page"]
    store[params[:store] == "ios" ? "ios" : "android"]
  end

  def petition
    @petition ||= petition_repository.find_by_id!(params[:petition_id])
  end

  def cycle
    @cycle ||= petition.plugin_relation.cycle
  end

  def petition_service
    @petition_service ||= PetitionService.new
  end

  def petition_repository
    @petition_repository ||= PetitionPlugin::DetailRepository.new
  end

  def set_page_title
    @page_title = case params[:action]
                  when "verify" then "Validar documento"
                  end
  end
end
