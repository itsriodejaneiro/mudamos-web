module Api
  module V3
    module Entities
      class ScopeCoverage < Grape::Entity

        root "scopes", "scope"

        expose :scope
        expose :uf
        expose :city, using: Api::V3::Entities::City

      end
    end
  end
end

