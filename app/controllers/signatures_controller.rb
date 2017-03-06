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
    [text.to_s].pack("H*").encode("utf-8")
  rescue Encoding::UndefinedConversionError
    Rails.logger.info("Invalid hexadecimal signature: #{text}")
    nil
  end
end
