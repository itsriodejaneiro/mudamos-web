module Api
  module V2
    module Entities
      class Cycle < Grape::Entity
        include Swagger::Blocks

        root 'cycles', 'cycle'

        expose :id
        expose :name
        expose :title
        expose :color
        expose :description

        with_options format_with: :iso_date_time do
          expose :initial_date
          expose :final_date
        end

        expose :pictures do
          expose :original do |cycle|
            normalize_url cycle.picture.url(:original)
          end

          expose :thumb do |cycle|
            normalize_url cycle.picture.url(:thumb)
          end

          expose :header do |cycle|
            normalize_url cycle.picture.url(:header)
          end
        end

        swagger_schema :'Api::V2::Entities::Cycle' do
          property :id do
            key :type, :integer
          end

          property :name do
            key :type, :string
          end

          property :title do
            key :type, :string
          end

          property :description do
            key :type, :string
          end

          property :color do
            key :type, :string
            format "HEX color"
          end

          property :initial_date do
            key :type, :string
            format "ISO date time"
          end

          property :final_date do
            key :type, :string
            format "ISO date time"
          end

          property :pictures do
            key :type, :object

            property :original do
              key :type, :string
              format "url"
            end

            property :thumb do
              key :type, :string
              format "url"
            end

            property :header do
              key :type, :string
              format "url"
            end
          end
        end
      end
    end
  end
end

