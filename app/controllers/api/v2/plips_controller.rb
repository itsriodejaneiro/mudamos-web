class Api::V2::PlipsController < Api::V2::ApplicationController
  include Swagger::Blocks

  attr_writer :phase_repository

  def plip_repository
    @plip_repository ||= PlipRepository.new
  end

  swagger_path "/plips" do
    operation :get do
      extend Api::V2::SwaggerResponses::InternalError

      key :description, "Returns all nationwide plips, optionally filtered by UF or city id"
      key :operationId, "v2findPlips"
      key :produces, ["application/json"]
      key :tags, ["plip"]

      parameter do
        key :name, :limit
        key :in, :query
        key :description, "Limit of plips on the response"
        key :type, :integer
      end

      parameter do
        key :name, :page
        key :in, :query
        key :description, "Which page of the pagination"
        key :type, :integer
      end

      parameter do
        key :name, :uf
        key :in, :query
        key :description, "The statewide plip UF"
        key :type, :string
      end

      parameter do
        key :name, :city_id
        key :in, :query
        key :description, "The citywide city id"
        key :type, :integer
      end

      parameter do
        key :name, :scope
        key :in, :query
        key :description, "Returns plips from the given scope"
        key :type, :list
        key :enum, %w(nationwide statewide citywide all)
        key :default, :all
      end

      parameter do
        key :name, :cause
        key :in, :query
        key :description, "Returns national causes"
        key :type, :boolean
      end

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
    plips = paginated_plips
    render json: paginated_response(Api::V2::Entities::Plip.represent(plips.items), plips)
  end

  private

  def paginated_plips
    limit = params[:limit]
    page = params[:page].try(:to_i) || 1
    filters = params.slice(:uf, :city_id, :scope, :cause)

    @paginated_plips ||= plip_repository.all_initiated(filters: filters, page: page, limit: limit)
  end
end
