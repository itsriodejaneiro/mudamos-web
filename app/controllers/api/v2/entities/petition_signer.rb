module Api
  module V2
    module Entities
      class PetitionSigner < Grape::Entity
        include Swagger::Blocks

        root 'signers', 'signers'

        expose :date
        expose :name
        expose :city
        expose :state
        expose :uf
        expose :profile_type
        expose :profile_id
        expose :profile_email
        expose :profile_picture

        swagger_schema :'Api::V2::Entities::PetitionSigner' do
          property :date do
            key :type, :string
            format "ISO date"
          end

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

          property :profile_type do
            key :type, :string
          end

          property :profile_id do
            key :type, :string
          end

          property :profile_email do
            key :type, :string
          end

          property :profile_picture do
            key :type, :string
          end
        end
      end
    end
  end
end

