class AddPluginRelationIdToMaterials < ActiveRecord::Migration
  def change
    add_reference :materials, :plugin_relation, index: true, foreign_key: true

    cycle = Cycle.find 'seguranca-publica'
    pr = cycle.plugin_relations.find_by_slug 'biblioteca'

    Material.find_each do |m|
      m.update_column(:plugin_relation_id, pr.id)
    end
  end
end
