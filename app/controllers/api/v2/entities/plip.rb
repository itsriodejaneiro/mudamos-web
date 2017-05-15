module Api
  module V2
    module Entities
      class Plip < Grape::Entity
        include Swagger::Blocks

        root 'plips', 'plip'

        expose :id
        expose :document_url
        expose :plip_url
        expose :content
        expose :presentation
        expose :initial_signatures_goal
        expose :total_signatures_required
        expose :signatures_required
        expose :call_to_action
        expose :video_id
        expose :cycle, using: Api::V2::Entities::Cycle
        expose :phase, using: Api::V2::Entities::Phase
        expose :scope_coverage, using: Api::V2::Entities::ScopeCoverage

        swagger_schema :'Api::V2::Entities::Plip' do
          property :id do
            key :type, :integer
          end

          property :document_url do
            key :type, :string
            format "url"
          end

          property :content do
            key :type, :string
          end

          property :presentation do
            key :type, :string
          end

          property :initial_signatures_goal do
            key :type, :integer
          end

          property :signatures_required do
            key :type, :integer
          end

          property :total_signatures_required do
            key :type, :integer
          end

          property :call_to_action do
            key :type, :string
          end

          property :video_id do
            key :type, :string
          end

          property :cycle do
            key :'$ref', :'Api::V2::Entities::Cycle'
          end

          property :phase do
            key :'$ref', :'Api::V2::Entities::Phase'
          end

          property :scope_coverage do
            key :'$ref', :'Api::V2::Entities::ScopeCoverage'
          end
        end
      end
    end
  end
end

