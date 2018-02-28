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
        key :enum, %w(nationwide statewide citywide all causes)
        key :default, :all
      end

      parameter do
        key :name, :include_causes
        key :in, :query
        key :description, "Returns national causes with the given scope"
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
    ttl = Rails.application.secrets.http_cache["api_expires_in"].minutes

    # Caching for better performance
    # Because the pagination is handled by http headers, we must manually provide them when caching
    plips_pagination = Rails.cache.fetch(index_cache_key, expires_in: ttl) do
      plips = paginated_plips
      json = paginated_response(Api::V2::Entities::Plip.represent(plips.items), plips).to_json

      {
        response: json,
        headers: headers.slice("X-Page", "X-Next-Page"),
      }
    end

    # Sets pagination headers even if there was a cache hit
    plips_pagination[:headers].each { |k, v| headers[k.to_s] = v }

    render json: plips_pagination[:response]
  end

  private

  def index_cache_key
    query = params.slice(
      :limit,
      :page,
      :uf,
      :city_id,
      :scope,
      :include_causes
    )
    ActionController::Caching::Actions::ActionCachePath.new(self, query).path
  end

  def paginated_plips
    limit = params[:limit]
    page = params[:page].try(:to_i) || 1
    filters = params.slice(:uf, :city_id, :scope, :include_causes)

    @paginated_plips ||= plip_repository.all_initiated(filters: filters, page: page, limit: limit)
  end
end
