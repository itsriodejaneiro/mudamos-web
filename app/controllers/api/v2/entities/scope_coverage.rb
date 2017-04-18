module Api
  module V2
    module Entities
      class ScopeCoverage < Grape::Entity
        include Swagger::Blocks

        root "scopes", "scope"

        expose :scope
        expose :uf
        expose :city, using: Api::V2::Entities::City

        swagger_schema :'Api::V2::Entities::ScopeCoverage' do
          property :scope do
            key :type, :string
          end

          property :uf do
            key :type, :string
          end

          property :city do
            key :'$ref', :'Api::V2::Entities::City'
          end
        end
      end
    end
  end
end

