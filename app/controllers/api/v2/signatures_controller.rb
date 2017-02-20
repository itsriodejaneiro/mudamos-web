class Api::V2::SignaturesController < Api::V2::ApplicationController
  include Swagger::Blocks

  attr_reader :signature_service

  def initialize(signature_service: SignatureService.new)
    @signature_service = signature_service
  end

  swagger_path "/signatures/{signature}" do
    operation :get do
      extend Api::V2::SwaggerResponses::InternalError

      key :description, "Returns the information of the signature"
      key :operationId, "v2findSignature"
      key :produces, ["application/json"]
      key :tags, ["signature"]

      response 200 do
        key :description, "signature response"
        schema do
          extend Api::V2::SwaggerResponses::SuccessResponse

          property :data do
            key :type, :object
            property 'signature' do
              key :'$ref', :'Api::V2::Entities::SignatureStatus'
            end
          end
        end
      end
    end
  end

  def show
    signature = signature_service.fetch_signature_status(params[:id])
    render json: { signature: signature }
  end
end
