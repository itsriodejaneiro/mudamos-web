module PetitionPlugin
  class PetitionSigner
    attr_accessor :presignature_repository
    attr_accessor :mailer

    def initialize(presignature_repository: PresignatureRepository.new,
                   mailer: PetitionPlugin::PreSignatureMailer)
      @presignature_repository = presignature_repository
      @mailer = mailer
    end

    def perform(user:, petition_detail_version:, user_password: nil)
      detail = petition_detail_version.petition_plugin_detail
      return false if presignature_repository.user_signed_petition? user.id, detail.plugin_relation_id

      presignature = Presignature.new(user_id: user.id, plugin_relation_id: detail.plugin_relation_id)
      presignature_repository.persist! presignature

      phase = detail.plugin_relation.related
      mailer.just_signed(user: user, phase: phase, user_password: user_password).deliver_later

      true
    end
  end
end
