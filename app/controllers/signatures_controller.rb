class SignaturesController < ApplicationController

  def show
    #@signature = signature_service.fetch_signature_status(params[:id])
    @signature = valid_signature
  end

  private

  #mocks
  SignatureStatus = Struct.new(:petition_name, :petition_page_url, :blockchain_updated_at, :updated_at, :user_name)
  def valid_signature
    SignatureStatus.new(
      "Petição bla",
      "http://localhost:3000/temas/help-mario-save-the-princess",
      Time.now,
      Time.now,
      "Davy Jones"
    )
  end

  def invalid_signature
  end

  private

  def signature_service
    @signature_service ||= SignatureService.new
  end
end
