module PetitionPlugin
  module InformationRelations
    extend ActiveSupport::Concern

    included do
      has_one :petition_information, class_name: 'PetitionPlugin::Information', dependent: :destroy
    end

  end
end
