class Api::V2::LaiPdfController < Api::V2::ApplicationController
  before_filter :is_token_valid

  include IbgeHelper

  def index
    return head :bad_request if get_city.nil?

    lai = LaiPdf.create(request_payload: lai_params, pdf_id: SecureRandom.uuid)

    LaiPdfGenerationWorker.perform_async id: lai.id

    head :no_content
  end

  private

  def get_city
    find_city_best_match(city: lai_params["city"], uf: lai_params["uf"])
  end

  def is_token_valid
    head :unauthorized unless bearer_token == Rails.application.secrets.apis["lai"]["auth_token"]
  end

  def bearer_token
    pattern = /^Bearer /
    authorization = request.authorization
    authorization.gsub(pattern, '') if authorization && authorization.match(pattern)
  end

  def lai_params
    @lai_params ||= params
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
