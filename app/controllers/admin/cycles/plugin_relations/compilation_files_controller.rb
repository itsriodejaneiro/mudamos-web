class Admin::Cycles::PluginRelations::CompilationFilesController < Admin::ApplicationController

  def update
    @plugin_relation = @cycle.plugin_relations.find params[:plugin_relation_id]
    @compilation_file = @plugin_relation.compilation_file
    if @compilation_file.id.to_s != params[:id].to_s
      flash[:error] = "Página inválida."
      redirect_to admin_path
    else
      if @compilation_file.update_attributes compilation_params
        flash[:success] = "Alterações da Relatoria efetuadas com sucesso."
      else
        flash[:error] = "Ocorreu algum erro ao salvar as alterações da Relatoria."
      end

      redirect_to [:admin, @cycle, @plugin_relation]
    end
  end

  private

    def compilation_params
      params.require(:compilation_file).permit(
        :title1,
        :title2,
        :title3,
        :file
      )
    end
end
