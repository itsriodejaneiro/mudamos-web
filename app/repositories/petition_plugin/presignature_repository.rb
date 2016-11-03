module PetitionPlugin
  class PresignatureRepository
    include Repository

    def user_signed_petition?(user_id, plugin_relation_id)
      PetitionPlugin::Presignature
        .where(user_id: user_id, plugin_relation_id: plugin_relation_id)
        .exists?
    end
  end
end
