module Api
  module V2
    module Entities
      class PetitionSigner < Grape::Entity
        include Swagger::Blocks

        root 'info', 'info'

        expose :name
        expose :city
        expose :state
        expose :uf

        swagger_schema :'Api::V2::Entities::PetitionSigner' do
          property :name do
            key :type, :string
          end

          property :city do
            key :type, :string
          end

          property :state do
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

