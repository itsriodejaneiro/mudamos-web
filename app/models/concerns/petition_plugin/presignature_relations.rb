module PetitionPlugin
  module PresignatureRelations
    extend ActiveSupport::Concern

    included do
      has_many :petition_presignatures, class_name: 'PetitionPlugin::Presignature', dependent: :destroy
    end

  end
end
