class Admin::SettingsController < Admin::ApplicationController
  def index
    @settings = Setting.all
  end

  def update
    @setting = Setting.find params[:id]

    if @setting.update_attributes setting_params
      flash[:success] = "Conteúdo alterado com sucesso."
    else
      flash[:error] = "Houve algum erro ao alterar o conteúdo"
    end

    @settings = Setting.all
    redirect_to [:admin, :settings]
  end

  private

    def setting_params
      return @setting_params if @setting_params

      @setting_params = params.require(:setting).permit(
        :value,
        :picture,
        :video_url
      )

      @setting_params[:picture] = nil if params[:setting][:picture_destroy].present?
      @setting_params
    end
end
