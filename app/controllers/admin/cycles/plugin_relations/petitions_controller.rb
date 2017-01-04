class Admin::Cycles::PluginRelations::PetitionsController < Admin::ApplicationController
  def index
    @petition = @plugin_relation.petition_information
  end

  def new
    @petition = PetitionPlugin::Information.new
  end

  def edit
    @petition = @plugin_relation.petition_information
  end

  def update
    @petition = @plugin_relation.petition_information
    @petition.update_attributes petition_params

    if @petition.save
      flash[:success] = "Petição salva com sucesso."
      redirect_to [:admin, @cycle, @plugin_relation, :petitions]
    else
      flash[:error] = "Ocorreu algum erro ao criar a petição."
      render :edit
    end
  end

  def create
    @petition = PetitionPlugin::Information.new.tap { |i| i.plugin_relation_id = @plugin_relation.id }
    @petition.update_attributes petition_params

    if @petition.save
      flash[:success] = "Petição salva com sucesso."
      redirect_to [:admin, @cycle, @plugin_relation, :petitions]
    else
      flash[:error] = "Ocorreu algum erro ao criar a petição."
      render :new
    end
  end

  private

  def petition_params
    params.require(:petition_plugin_information)
      .permit(:call_to_action, :signatures_required, :document_url, :presentation, :body)
  end
end
