module Api
  module V2
    module Entities
      class PetitionInfo < Grape::Entity
        include Swagger::Blocks

        root 'info', 'info'

        expose :updated_at
        expose :signatures_count
        expose :blockchain_address

        swagger_schema :'Api::V2::Entities::PetitionInfo' do
          property :updated_at do
            key :type, :string
            format "ISO date"
          end

          property :signatures_count do
            key :type, :integer
          end

          property :blockchain_address do
            key :type, :string
          end
        end
      end
    end
  end
end

