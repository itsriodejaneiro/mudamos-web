class Api::V2::LaiPdfController < Api::V2::ApplicationController
  before_filter :is_token_valid

  def index
    lai = LaiPdf.create(request_payload: lai_params, pdf_id: SecureRandom.uuid)

    LaiPdfGenerationWorker.perform_async id: lai.id

    head :no_content
  end

  private

  def is_token_valid
    head :unauthorized unless bearer_token == Rails.application.secrets.apis["web"]["auth_token"]
  end

  def bearer_token
    pattern = /^Bearer /
    authorization = request.authorization
    authorization.gsub(pattern, '') if authorization && authorization.match(pattern)
  end

  def lai_params
      params
        .permit(%i(
          uf
          city
          create_lai
          city_confirm
          has_justification
          justification
          name
          email
        ))
    end
end