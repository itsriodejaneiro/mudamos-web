module Api
  module V2
    module Entities
      class SignatureStatus < Grape::Entity
        include Swagger::Blocks

        root 'signature', 'signature'

        expose :petition_name
        expose :petition_page_url
        expose :blockchain_updated_at
        expose :updated_at
        expose :user_name
        expose :signatures_pdf_url

        swagger_schema :'Api::V2::Entities::SignatureStatus' do
          property :petition_name do
            key :type, :string
          end

          property :petition_page_url do
            key :type, :string
          end

          property :blockchain_updated_at do
            key :type, :string
            format "ISO date"
          end

          property :updated_at do
            key :type, :string
            format "ISO date"
          end

          property :user_name do
            key :type, :string
          end

          property :signatures_pdf_url do
            key :type, :string
          end
        end
      end
    end
  end
end

