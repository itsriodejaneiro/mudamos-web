module Api
  module V2
    module Entities
      class PetitionStatus < Grape::Entity
        include Swagger::Blocks

        root 'status', 'status'

        expose :status
        expose :blockstamp
        expose :transaction
        expose :transaction_date

        swagger_schema :'Api::V2::Entities::PetitionStatus' do
          property :status do
            key :type, :string
          end

          property :blockstamp do
            key :type, :string
            format "ISO date"
          end

          property :transaction do
            key :type, :string
          end

          property :transaction_date do
            key :type, :string
            format "ISO date"
          end
        end
      end
    end
  end
end

