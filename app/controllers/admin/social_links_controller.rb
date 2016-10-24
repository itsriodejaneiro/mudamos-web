class Admin::SocialLinksController < Admin::ApplicationController
  def create
    @social_link = SocialLink.new social_link_params

    if @social_link.save
      flash[:success] = "Nova rede social adicionada com sucesso."
    else
      flash[:error] = "Não foi possível adicionar a nova Rede Social."
    end

    @settings = Setting.all
    redirect_to [:admin, :settings]
  end

  def update
    @social_link = SocialLink.find params[:id]

    if @social_link.update_attributes social_link_params
      flash[:success] = "Rede Social alterada com sucesso."
    else
      flash[:error] = "Houve algum erro ao alterar o conteúdo."
    end

    @settings = Setting.all
    redirect_to [:admin, :settings]
  end

  def destroy
    @social_link = SocialLink.find params[:id]

    if @social_link.destroy
      flash[:success] = "Rede Social removida com sucesso."
    else
      flash[:error] = "Houve algum erro ao remover a rede social."
    end

    @settings = Setting.all
    redirect_to [:admin, :settings]
  end

  private

    def social_link_params
      params.require(:social_link).permit(
        :provider,
        :link,
        :icon_class,
        :description
      )
    end
end
