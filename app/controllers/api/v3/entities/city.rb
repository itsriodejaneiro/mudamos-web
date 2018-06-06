module Api
  module V3
    module Entities
      class City < Grape::Entity

        root "cities", "city"

        expose :id
        expose :name
        expose :uf

      end
    end
  end
end
