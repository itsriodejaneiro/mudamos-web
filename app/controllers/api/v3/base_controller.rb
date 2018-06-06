require_dependency 'api/entities_helpers'

class Api::V3::BaseController < ActionController::Base

  rescue_from StandardError do |e|
    Rails.logger.error error_for(error: e)

    error = Api::V2::Responses::InternalError.new
    render json: error, status: error.code
  end

  def error_for(error:)
    err = "error: #{error.class.name} message: #{error.message}\n\n#{error.backtrace.join("\n")}"
    if error.cause
      "#{err}\n====== Caused By:\n#{error_for(error: error.cause)}"
    else
      err
    end
  end

  def paginated_response(representation, pagination)
    headers["X-Page"] = pagination.page.to_s
    headers["X-Next-Page"] = (pagination.page + 1).to_s if pagination.has_next

    success_response(representation)
  end

  def success_response(data)
    Api::V2::Responses::SuccessResponse.new(data: data)
  end
end
