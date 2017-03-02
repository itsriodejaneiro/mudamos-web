require "base64"

class SignaturesController < ApplicationController

  def show
    id = parse_signature_id(params[:id])
    @signature = signature_service.fetch_signature_status(id) if id.present?
  end

  private

  def signature_service
    @signature_service ||= SignatureService.new
  end

  def parse_signature_id(text)
    Base64.strict_decode64(text.to_s)
  rescue ArgumentError
    Rails.logger.info("Invalid signature")
    nil
  end
end
