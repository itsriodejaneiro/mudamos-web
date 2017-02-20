class SignaturesController < ApplicationController

  def show
    @signature = signature_service.fetch_signature_status(params[:id])
  end

  private

  def signature_service
    @signature_service ||= SignatureService.new
  end
end
