require_dependency 'api/entities_helpers'

module Api
  module V3
    module Entities
      class Plip < Grape::Entity

        root 'plips', 'plip'

        expose :id
        expose :detail_id

        with_options format_with: :iso_date_time do
          expose :created_at
        end

        expose :document_url
        expose :plip_url
        expose :content
        expose :presentation
        expose :total_signatures_required
        expose :call_to_action
        expose :video_id
        expose :share_link
        expose :requires_mobile_validation

        expose :pictures do
          expose :original do |plip|
            normalize_url plip.cycle.picture.url(:original)
          end

          expose :thumb do |plip|
            normalize_url plip.cycle.picture.url(:thumb)
          end

          expose :header do |plip|
            normalize_url plip.cycle.picture.url(:header)
          end
        end

        expose :title do |plip|
          plip.phase.name
        end

        expose :subtitle do |plip|
          plip.phase.description
        end

        with_options format_with: :iso_date_time do
          expose :initial_date
          expose :final_date
        end

        expose :scope_coverage, using: Api::V3::Entities::ScopeCoverage
      end
    end
  end
end

