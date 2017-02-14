class PartnersApi::UsersController < PartnersApi::ApplicationController

  attr_reader :user_service
  attr_reader :plip_repository
  attr_reader :petition_signer
  attr_reader :petition_plugin_detail_version_repository

  def initialize(
    user_service: UserService.new,
    plip_repository: PlipRepository.new,
    petition_signer: PetitionPlugin::PetitionSigner.new,
    petition_plugin_detail_version_repository: PetitionPlugin::DetailVersionRepository.new
  )
    @user_service = user_service
    @plip_repository = plip_repository
    @petition_signer = petition_signer
    @petition_plugin_detail_version_repository = petition_plugin_detail_version_repository
  end

  def create
    user_params = params.permit(:email, :name, :encrypted_password)
    user = user_service.create_user_with_password(
      email: user_params["email"],
      name: user_params["name"],
      encrypted_password: user_params["encrypted_password"]
    )
    
    if user.valid?
      current_plip = plip_repository.current_plip

      if current_plip.present?
        petition_detail_version = petition_plugin_detail_version_repository.find_by_id!(current_plip.id)
        petition_signer.perform(
          user_id: user.id,
          plugin_relation_id: petition_detail_version.petition_plugin_detail.plugin_relation.id
        )
      end

      head 204
    else
      render json: user.errors, status: 422
    end
  end
end
