class PartnersApi::PetitionsController < PartnersApi::ApplicationController
  attr_writer :plip_repository
  attr_writer :petition_signer
  attr_writer :detail_version_repository
  attr_writer :user_creator

  def plip_repository
    @plip_repository ||= PlipRepository.new
  end

  def petition_signer
    @petition_signer ||= PetitionPlugin::PetitionSigner.new
  end

  def detail_version_repository
    @detail_version_repository ||= PetitionPlugin::DetailVersionRepository.new
  end

  def user_service
    @user_service ||= UserService.new
  end

  def show
    render json: {}
  end

  def pre_sign
    # TODO: move this logic to a use case

    petition_detail_version = detail_version_repository.find_by_id(params[:petition_id])

    unless petition_detail_version
      return render json: { message: "Projeto não encontrado" }, status: 404
    end

    detail = petition_detail_version.petition_plugin_detail

    unless detail.plugin_relation.related.in_progress?
      return render json: { error: "Fase terminada" }, status: 403
    end

    user_params = params.permit(:email, :name).deep_symbolize_keys
    result = user_service.create_user_with_auto_password(user_params)

    if result.success
      petition_signer.perform(
        user: result.user,
        petition_detail_version: petition_detail_version,
        user_password: result.password,
      )

      head 204
    else
      render json: result.user.errors, status: 422
    end
  end
end
