module Api
  module V2
    module Entities
      class Plip < Grape::Entity
        include Swagger::Blocks

        root 'plips', 'plip'

        expose :document_url
        expose :content
        expose :cycle, using: Api::V2::Entities::Cycle
        expose :phase, using: Api::V2::Entities::Phase

        swagger_schema :'Api::V2::Entities::Plip' do
          property :document_url do
            key :type, :string
            format "url"
          end

          property :content do
            key :type, :string
          end

          property :cycle do
            key :'$ref', :'Api::V2::Entities::Cycle'
          end

          property :phase do
            key :'$ref', :'Api::V2::Entities::Phase'
          end
        end
      end
    end
  end
end

