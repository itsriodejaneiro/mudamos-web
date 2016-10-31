module Api::V2::SwaggerResponses
  module InternalError
    def self.extended(base)
      base.response 500 do
        key :description, "internal error"
        schema do
          key :'$ref', :'Api::V2::Responses::InternalError'
        end
      end
    end
  end

  module PaginatedHeaders
    def self.extended(base)
      base.header "X-Page" do
        key :type, :integer
        key :description, "Current page index"
      end

      base.header "X-Next-Page" do
        key :type, :integer
        key :description, "Next page index if available"
      end
    end
  end

  module SuccessResponse
    def self.extended(base)
      base.key :type, :object
      base.property :success do
        key :type, :string
        key :default, "success"
      end
    end
  end

  module BaseResponse
    def self.extended(base)
      base.property :status do
        key :type, :string
      end

      base.property :data do
        key :type, :object
      end
    end
  end
end
