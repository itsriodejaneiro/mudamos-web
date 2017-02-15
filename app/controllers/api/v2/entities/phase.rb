module Api
  module V2
    module Entities
      class Phase < Grape::Entity
        include Swagger::Blocks

        root 'phases', 'phase'

        expose :id
        expose :cycle_id
        expose :name
        expose :description
        expose :current_status, as: :status

        with_options format_with: :iso_date_time do
          expose :initial_date
          expose :final_date
        end

        swagger_schema :'Api::V2::Entities::Phase' do
          property :id do
            key :type, :integer
          end

          property :cycle_id do
            key :type, :integer
          end

          property :name do
            key :type, :string
          end

          property :description do
            key :type, :string
          end

          property :status do
            key :type, :string
            key :enum, ::Phase.human_statuses
          end

          property :initial_date do
            key :type, :string
            format "ISO date"
          end

          property :final_date do
            key :type, :string
            format "ISO date time"
          end
        end
      end
    end
  end
end
