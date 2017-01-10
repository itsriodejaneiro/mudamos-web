module PetitionPlugin
  module DetailRelations
    extend ActiveSupport::Concern

    included do
      has_one :petition_detail, class_name: 'PetitionPlugin::Detail', dependent: :destroy
    end

  end
end
