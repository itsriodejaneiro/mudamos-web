class Api::V2::PlipsController < Api::V2::ApplicationController
  include Swagger::Blocks

  attr_writer :phase_repository

  def plip_repository
    @plip_repository ||= PlipRepository.new
  end

  swagger_path "/plips" do
    operation :get do
      extend Api::V2::SwaggerResponses::InternalError

      key :description, "Returns all plips"
      key :operationId, "v2findPlips"
      key :produces, ["application/json"]
      key :tags, ["plip"]

      response 200 do
        extend Api::V2::SwaggerResponses::PaginatedHeaders

        key :description, "plips success response"
        schema do
          extend Api::V2::SwaggerResponses::SuccessResponse

          property :data do
            key :type, :object
            property 'plips' do
              key :'$ref', :'Api::V2::Entities::Plip'
            end
          end
        end
      end
    end
  end

  def index
    render json: paginated_response(Api::V2::Entities::Plip.represent(paginated_plips.items), paginated_plips)
  end

  private

  def paginated_plips
    @paginated_plips ||= plip_repository.all_initiated(limit: 1)
  end
end
