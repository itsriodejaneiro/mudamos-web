class Api::V2::ApidocsController < Api::V2::BaseController
  include Swagger::Blocks

  swagger_root do
    key :swagger, "2.0"
    info do
      key :version, "2.0.0"
      key :title, "Mudamos"
      key :description, "Mudamos api"
      license do
        key :name, "CC BY-NC-SA 4.0"
      end
    end
    tag do
      key :name, "plip"
      key :description, "Plips operations"
    end
    key :basePath, "/api/v2"
    key :consumes, ["application/json"]
    key :produces, ["application/json"]
  end

  # A list of all classes that have swagger_* declarations.
  SWAGGERED_CLASSES = [
    Api::V2::PetitionsController,
    Api::V2::PlipsController,
    Api::V2::Entities::Cycle,
    Api::V2::Entities::Phase,
    Api::V2::Entities::Plip,
    Api::V2::Responses::InternalError,
    self,
  ].freeze

  def index
    render json: Swagger::Blocks.build_root_json(SWAGGERED_CLASSES)
  end
end
