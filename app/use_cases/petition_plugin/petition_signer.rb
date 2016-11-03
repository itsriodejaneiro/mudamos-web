module PetitionPlugin
  class PetitionSigner
    attr_accessor :presignature_repository

    def initialize(presignature_repository: PresignatureRepository.new)
      @presignature_repository = presignature_repository
    end

    def perform(user_id:, plugin_relation_id:)
      return false if presignature_repository.user_signed_petition? user_id, plugin_relation_id

      presignature = Presignature.new(user_id: user_id, plugin_relation_id: plugin_relation_id)
      presignature_repository.persist! presignature
    end
  end
end
