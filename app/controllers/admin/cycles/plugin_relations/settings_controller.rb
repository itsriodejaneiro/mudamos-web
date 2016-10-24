class Admin::Cycles::PluginRelations::SettingsController < Admin::ApplicationController

  def create
    @setting = Setting.new setting_params

    if @setting.save
      flash[:success] = "Conteúdo alterado com sucesso."
    else
      flash[:error] = "Houve algum erro ao alterar o conteúdo"
    end

    redirect_to [:admin, @cycle, @plugin_relation]
  end

  def update
    @setting = Setting.find params[:id]

    if @setting.update_attributes setting_params
      flash[:success] = "Conteúdo alterado com sucesso."
    else
      flash[:error] = "Houve algum erro ao alterar o conteúdo"
    end

    redirect_to [:admin, @cycle, @plugin_relation]
  end

  private

    def setting_params
      params.require(:setting).permit(
        :key,
        :value,
        :picture
      )
    end
end
