class AddSlugToPluginRelations < ActiveRecord::Migration
  def change
    add_column :plugin_relations, :slug, :string

    PluginRelation.find_each(&:save)
  end
end
