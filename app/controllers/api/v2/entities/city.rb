module Api
  module V2
    module Entities
      class City < Grape::Entity
        include Swagger::Blocks

        root "cities", "city"

        expose :id
        expose :name
        expose :uf

        swagger_schema :'Api::V2::Entities::City' do
          property :id do
            key :type, :integer
          end

          property :name do
            key :type, :string
          end

          property :uf do
            key :type, :string
          end
        end
      end
    end
  end
end

