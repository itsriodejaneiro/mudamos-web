class Admin::Cycles::PluginRelationsController < Admin::ApplicationController
  def show
    @plugin_relation = @cycle.plugin_relations.find params[:id]

    case @plugin_relation.plugin.plugin_type
    when 'Discussão'
      redirect_to [:admin, @cycle, @plugin_relation, :subjects]
    when 'Relatoria'
      render 'compilation'
    when 'Biblioteca'
      redirect_to [:admin, @cycle, @plugin_relation, :materials]
    when 'Glossário'
      redirect_to [:admin, @cycle, @plugin_relation, :vocabularies]
    when 'Blog'
      redirect_to [:admin, @cycle, :blog_posts]
    end
  end

end
